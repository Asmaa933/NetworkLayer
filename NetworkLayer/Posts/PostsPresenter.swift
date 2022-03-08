//
//  Presenter.swift
//  NetworkLayer
//
//  Created by Asmaa Tarek on 05/05/2021.
//

import Foundation

//MARK: - PostsVC

protocol PostsPresenterProtocol: AnyObject {
    func getPosts()
    func getPost(at index: Int) -> Post
    func getPostsCount() -> Int
}

//MARK: - PostsVC

class PostsPresenter {
    
    //MARK: - PostsVC

    private weak var view: PostsViewProtocol!
    private var posts = [Post]()
    
    //MARK: - Init

    init(view: PostsViewProtocol) {
        self.view = view
      
    }
}

//MARK: - PostsPresenter Protocol Implementation

extension PostsPresenter: PostsPresenterProtocol {
    func getPosts() {
        startRequest(request: .getPosts, mappingClass: [Post].self).done {[weak self] result in
            guard let self = self else {return}
            self.posts = result
            self.view.reloadTableView()
        }.catch { error in
            
        }
    }
    
    func getPost(at index: Int) -> Post {
        return posts[index]
    }
    
    func getPostsCount() -> Int {
        return posts.count
    }
}


