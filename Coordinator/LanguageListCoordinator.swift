//
//  LanguageListCoordinator.swift
//  iOS-ArchitectureDemo
//
//  Created by Lingye Han on 2021/3/5.
//

import Foundation
import UIKit
import RxSwift

/// Type that defines possible coordination results of the `LanguageListCoordinator`.
///
/// - language: Language was choosen.
/// - cancel: Cancel button was tapped.
enum LanguageListCoordinationResult {
    case language(String)
    case cancel
}

class LanguageListCoordinator: BaseCoordinator<LanguageListCoordinationResult> {

    private let rootViewController: UIViewController

    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }

    override func start() -> Observable<CoordinationResult> {
        let viewController = MVVMRxLanguageListViewController()
        let navigationController = UINavigationController(rootViewController: viewController)

        let viewModel = MVVMRxLanguageListViewModel()
        viewController.viewModel = viewModel

        let cancel = viewModel.didCancel.map { _ in CoordinationResult.cancel }
        let language = viewModel.didSelectLanguage.map { CoordinationResult.language($0) }

        rootViewController.present(navigationController, animated: true)

        return Observable.merge(cancel, language)
            .take(1)
            .do(onNext: { [weak self] _ in self?.rootViewController.dismiss(animated: true) })
    }
}
