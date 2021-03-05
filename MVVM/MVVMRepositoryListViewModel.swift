//
//  MVVMRepositoryListViewModel.swift
//  iOS-ArchitectureDemo
//
//  Created by Lingye Han on 2021/3/5.
//

import Foundation

protocol MVVMRepositoryListViewModelDelegate {
    func startLoading()
    func finishLoading()
    func reloadData()
    func showAlert(message: String)
}

class MVVMRepositoryListViewModel {
    private let githubService: GithubService
    var repositories = [Repository]()
    var currentLanguage = "Swift"
    
    var delegate: MVVMRepositoryListViewModelDelegate?
    
    init(githubService: GithubService = GithubService()) {
        self.githubService = githubService
    }
    
    func loadData(byLanguage language: String) {
        currentLanguage = language
        
        delegate?.startLoading()
        githubService.getMostPopularRepositories(byLanguage: language) { [weak self] result in
            self?.delegate?.finishLoading()
            switch result {
            case .success(let repositories):
                self?.repositories = repositories
                self?.delegate?.reloadData()
                self?.delegate?.finishLoading()
            case .failure(let error):
                self?.delegate?.showAlert(message: error.localizedDescription)
            }
        }
    }
}
