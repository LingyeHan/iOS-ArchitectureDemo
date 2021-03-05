//
//  RepositoryListPresenter.swift
//  iOS-ArchitectureDemo
//
//  Created by Lingye Han on 2021/1/28.
//

import Foundation

/*
 M (Model) 模型只暴露给 Presenter
 V (View+ViewController) Controller 视图不知道模型，只负责更新UI或从UI获取输入,依赖演示者来保存数据或做任何逻辑更改。
 P (Presenter)
 
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
    
//    func detachView() {
//        self.view = nil
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
