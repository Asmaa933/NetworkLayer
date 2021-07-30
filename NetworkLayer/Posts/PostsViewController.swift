//
//  ViewController.swift
//  NetworkLayer
//
//  Created by Asmaa Tarek on 05/05/2021.
//

import UIKit

import UIKit

//MARK: - PostsViewProtocol

protocol PostsViewProtocol: AnyObject, BaseViewProtocol {
    func reloadTableView()
}

//MARK: - PostsVC

class PostsViewController: BaseController {
    
    //MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private lazy var presenter: PostsPresenterProtocol = PostsPresenter(view: self)
    
    //MARK: - PostsViewProtocol

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.getPosts()
    }

}

extension PostsViewController: PostsViewProtocol {
    func reloadTableView() {
        tableView.reloadData()
    }
}

extension PostsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getPostsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = presenter.getPost(at: indexPath.row).title ?? ""
        return cell
    }
}
