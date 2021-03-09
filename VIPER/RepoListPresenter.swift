//
//  RepoListPresenter.swift
//  iOS-ArchitectureDemo
//
//  Created by Lingye Han on 2021/3/5.
//

import Foundation

/**
 Presenter是View和业务之间的中转站，它不包含业务实现代码，而是负责调用现成的各种Use Case，将具体事件转化为具体业务。Presenter里不应该导入UIKit，否则就有可能入侵View层的渲染工作。
 Presenter里也不应该出现Model类，当数据从Interactor传递到Presenter里时，应该转变为简单的数据结构。
     接收并处理来自View的事件
     向Interactor请求调用业务逻辑
     向Interactor提供View中的数据
     接收并处理来自Interactor的数据回调事件
     通知View进行更新操作
     通过Router跳转到其他View
 Presenter:
    Update
    Fetch Data
    Navigate
 https://github.com/MindorksOpenSource/iOS-Viper-Architecture
 */

// MARK: - RepoListPresenterInputInterface declaration

protocol RepoListPresenterInputInterface: class {
    func getCurrentLanguage() -> String
    func getDataSource() -> [Repository]
    func updateView(byLanguage language: String)
    func didSelectRepo(_ repo: Repository)
}

// MARK: - RepoListPresenter

class RepoListPresenter {
    
    // Reference to the View
    weak var view: RepoListInputInterface?
    
    // Reference to the Interactor's interface.
    var interactor: RepoListInteractorInputInterface?
    
    // Reference to the Router
    var router: RepoListRouter?
    
    // DataSource fetched by Interactor
    var dataSource: [Repository] = []
    
    var currentLanguage: String = "Swift"
}

// MARK: - RepoListPresenterInputInterface

extension RepoListPresenter: RepoListPresenterInputInterface {
    func getCurrentLanguage() -> String {
        return currentLanguage
    }

    func getDataSource() -> [Repository] {
        return dataSource
    }
    
    func updateView(byLanguage language: String) {
        self.currentLanguage = language
        view?.loadingIndicator(show: true)
        self.interactor?.loadData(byLanguage: language)
    }
    
    func didSelectRepo(_ repo: Repository) {
        router?.presentRepository(repo)
    }
}

// MARK: - RepoListInteractorOutputInterface

extension RepoListPresenter: RepoListInteractorOutputInterface {
    func didFinishLoad(_ repositories: [Repository]) {
        dataSource = repositories
        view?.reloadData()
        view?.loadingIndicator(show: false)
    }
    
    func didFailLoad(_ error: Error) {
        view?.showAlert(message: error.localizedDescription)
    }
}

