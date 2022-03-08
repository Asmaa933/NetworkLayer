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
    private var posts = [Post]() {
        didSet {
            view.reloadTableView()
        }
    }
    
    //MARK: - Init

    init(view: PostsViewProtocol) {
        self.view = view
      
    }
}

//MARK: - PostsPresenter Protocol Implementation

extension PostsPresenter: PostsPresenterProtocol {
    
    func getPosts() {
        NetworkManager.shared.fetchData(request: NetworkAPI.getPosts,
                                        mappingClass: [Post].self) { [weak self] result in
            guard let self = self else { return }
            self.handlePostsResult(result)
        }
    }
    
    func getPost(at index: Int) -> Post {
        return posts[index]
    }
    
    func getPostsCount() -> Int {
        return posts.count
    }
}

fileprivate extension PostsPresenter {
    func handlePostsResult(_ result: Result<[Post], Error>) {
        switch result {
        case .success(let posts):
            self.posts = posts
        case .failure(let error):
            debugPrint(error.localizedDescription)
        }
    }
}

