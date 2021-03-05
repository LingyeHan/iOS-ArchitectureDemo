//
//  AppDelegate.swift
//  iOS-ArchitectureDemo
//
//  Created by Lingye Han on 2021/1/27.
//

import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        //setupRootViewController()
        setupAppCoordinator()
        
        return true
    }
    
    func setupRootViewController() {
        //let vc = MVCRepositoryListViewController()
        //let vc = MVPRepositoryListViewController()
        let vc = MVVMRxRepositoryListViewController()
        window?.rootViewController = UINavigationController(rootViewController: vc)
    }
    
    private let disposeBag = DisposeBag()
    private var appCoordinator: AppCoordinator!
    func setupAppCoordinator() {
        appCoordinator = AppCoordinator(window: window!)
        appCoordinator.start()
            .subscribe()
            .disposed(by: disposeBag)
    }
}

