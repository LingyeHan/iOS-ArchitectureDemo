//
//  AppDelegate.swift
//  iOS-ArchitectureDemo
//
//  Created by Lingye Han on 2021/1/27.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        //let vc = MVCRepositoryListViewController()
        let vc = MVPRepositoryListViewController()
        window?.rootViewController = UINavigationController(rootViewController: vc)
        
        return true
    }
}

