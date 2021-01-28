//
//  LanguageListPresenter.swift
//  iOS-ArchitectureDemo
//
//  Created by Lingye Han on 2021/1/28.
//

import Foundation

protocol LanguageListView: class {
    func reloadData()
}

class LanguageListPresenter {
    private let githubService: GithubService
    private weak var view: LanguageListView!
    
    var languages = [String]()
    
    init(view: LanguageListView, githubService: GithubService = GithubService()) {
        self.view = view
        self.githubService = githubService
    }
    
    func loadData() {
        githubService.getLanguageList { [weak self] languages in
            self?.languages = languages
            self?.view.reloadData()
        }
    }
}
