//
//  RepoListInteractor.swift
//  iOS-ArchitectureDemo
//
//  Created by Lingye Han on 2021/3/5.
//

import Foundation

/**
 Interactor是业务的实现者和维护者，它会调用各种Service来实现业务逻辑，封装成明确的用例。而这些Service在使用时，也都是基于接口的，因为Interactor的实现不和具体的类绑定，而是由Application注入Interactor需要的Service。
 1. 维护主要的业务逻辑功能，向Presenter提供现有的业务用例
 2. 维护、获取、更新Entity
 3. 当有业务相关的事件发生时，处理事件，并通知Presenter
 Interactor:
    Fetch Data
    Prepare Data
 */

// MARK: - RepoListInteractorInputInterface declaration

protocol RepoListInteractorInputInterface: class {
    
    func loadData(byLanguage language: String)
}

// MARK: - RepoListInteractorOutputInterface declaration

protocol RepoListInteractorOutputInterface: class {
    
    func didFinishLoadData(_ repositories: [Repository])
    func loadDataFailure(_ error: Error)
}

// MARK: - RepoListInteractor

class RepoListInteractor {
    private let githubService: GithubService = GithubService()
    
    // Reference to the Presenter's output interface.
    weak var presenter: RepoListInteractorOutputInterface?
}

// MARK: - RepoListInteractorInputInterface

extension RepoListInteractor: RepoListInteractorInputInterface {
    
    func loadData(byLanguage language: String) {
        githubService.getMostPopularRepositories(byLanguage: language) { [weak self] result in
            switch result {
            case .success(let repositories):
                self?.presenter?.loadDataSuccess(repositories)
            case .failure(let error):
                self?.presenter?.loadDataFailure(error)
            }
        }
    }
}
