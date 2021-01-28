//
//  RepositoryListPresenter.swift
//  iOS-ArchitectureDemo
//
//  Created by Lingye Han on 2021/1/28.
//

import Foundation

/*
 MVP 三种实现模式:
 监视控制器 Supervision Controller (The closest pattern to MVC)
 展示模型 Presentation Model (The View doesn’t have a direct access to the Model)
 被动视图 Passive View
 */

protocol RepositoryListView: class {
    func startLoading()
    func finishLoading()
    func reloadData()
    func showAlert(message: String)
}

class RepositoryListPresenter {
    private let githubService: GithubService
    private weak var view: RepositoryListView!
    
    var currentLanguage = ""
    var repositories = [Repository]()
    
    init(view: RepositoryListView, githubService: GithubService = GithubService()) {
        self.view = view
        self.githubService = githubService
    }
    
//    func attachView(_ view: RepositoryListView) {
//        self.view = view
//    }
    
    func loadData(byLanguage language: String = "Swift") {
        currentLanguage = language
        
        view.startLoading()
        githubService.getMostPopularRepositories(byLanguage: language) { [weak self] result in
            self?.view.finishLoading()
            switch result {
            case .success(let repositories):
                self?.repositories = repositories
                self?.view.reloadData()
            case .failure(let error):
                self?.view.showAlert(message: error.localizedDescription)
            }
        }
    }
}
