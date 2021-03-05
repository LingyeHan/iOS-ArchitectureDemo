//
//  MVVMRxLanguageListViewModel.swift
//  iOS-ArchitectureDemo
//
//  Created by Lingye Han on 2021/3/5.
//

import Foundation
import RxSwift

class MVVMRxLanguageListViewModel {

    // MARK: - Inputs

    let selectLanguage: AnyObserver<String>
    let cancel: AnyObserver<Void>

    // MARK: - Outputs

    let languages: Observable<[String]>
    let didSelectLanguage: Observable<String>
    let didCancel: Observable<Void>

    init(githubService: RxGithubService = RxGithubService()) {
        self.languages = githubService.getLanguageList()

        let _selectLanguage = PublishSubject<String>()
        self.selectLanguage = _selectLanguage.asObserver()
        self.didSelectLanguage = _selectLanguage.asObservable()

        let _cancel = PublishSubject<Void>()
        self.cancel = _cancel.asObserver()
        self.didCancel = _cancel.asObservable()
    }
}
