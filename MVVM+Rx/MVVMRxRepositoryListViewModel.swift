//
//  MVVMRxRepositoryListViewModel.swift
//  iOS-ArchitectureDemo
//
//  Created by Lingye Han on 2021/3/5.
//

import Foundation
import RxSwift

class RepositoryViewModel {
    let name: String
    let description: String
    let starsCountText: String
    let url: URL

    init(repository: Repository) {
        self.name = repository.fullName
        self.description = repository.description
        self.starsCountText = "⭐️ \(repository.starsCount)"
        self.url = URL(string: repository.url)!
    }
}

class MVVMRxRepositoryListViewModel {

    // MARK: - Inputs

    /// Call to update current language. Causes reload of the repositories.
    let setCurrentLanguage: AnyObserver<String>

    /// Call to show language list screen.
    let chooseLanguage: AnyObserver<Void>

    /// Call to open repository page.
    let selectRepository: AnyObserver<RepositoryViewModel>

    /// Call to reload repositories.
    let reload: AnyObserver<Void>

    // MARK: - Outputs

    /// Emits an array of fetched repositories.
    let repositories: Observable<[RepositoryViewModel]>

    /// Emits a formatted title for a navigation item.
    let title: Observable<String>

    /// Emits an error messages to be shown.
    let alertMessage: Observable<String>

    /// Emits an url of repository page to be shown.
    let showRepository: Observable<URL>

    /// Emits when we should show language list.
    let showLanguageList: Observable<Void>

    init(initialLanguage: String, githubService: RxGithubService = RxGithubService()) {

        let _reload = PublishSubject<Void>()
        self.reload = _reload.asObserver()

        let _currentLanguage = BehaviorSubject<String>(value: initialLanguage)
        self.setCurrentLanguage = _currentLanguage.asObserver()

        self.title = _currentLanguage.asObservable()
            .map { "\($0)" }

        let _alertMessage = PublishSubject<String>()
        self.alertMessage = _alertMessage.asObservable()

        self.repositories = Observable.combineLatest(_reload, _currentLanguage) { _, language in language }
            .flatMapLatest { language in
                githubService.getMostPopularRepositories(byLanguage: language)
                    .catch { error in
                        _alertMessage.onNext(error.localizedDescription)
                        return Observable.empty()
                    }
            }
            .map { repositories in repositories.map(RepositoryViewModel.init) }

        let _selectRepository = PublishSubject<RepositoryViewModel>()
        self.selectRepository = _selectRepository.asObserver()
        self.showRepository = _selectRepository.asObservable()
            .map { $0.url }

        let _chooseLanguage = PublishSubject<Void>()
        self.chooseLanguage = _chooseLanguage.asObserver()
        self.showLanguageList = _chooseLanguage.asObservable()
    }
}
