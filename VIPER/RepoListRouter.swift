//
//  RepoListRouter.swift
//  iOS-ArchitectureDemo
//
//  Created by Lingye Han on 2021/3/5.
//

import Foundation
import UIKit
import SafariServices

/**
 Wireframe:
    Navigate
    Setup module components
 提供View之间的跳转功能，减少了模块间的耦合
 初始化VIPER的各个模块
 */

class RepoListRouter {
    
    weak var viewController: UIViewController?
    
    static func assembleModule() -> UIViewController? {
        
        let view: RepoListViewController = RepoListViewController()
        let presenter = RepoListPresenter()
        let interactor = RepoListInteractor()
        let router = RepoListRouter()
        
        let  navigationController = UINavigationController(rootViewController: view)
        
        view.presenter = presenter
        presenter.view = view as! RepoListInputInterface
        
        presenter.router = router
        
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        router.viewController = view
        
        return navigationController
    }
    
    func presentRepository(_ repository: Repository) {
        let url = URL(string: repository.url)!
        let safariViewController = SFSafariViewController(url: url)
        viewController?.navigationController?.pushViewController(safariViewController, animated: true)
    }
}
