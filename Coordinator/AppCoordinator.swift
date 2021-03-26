//
//  AppCoordinator.swift
//  iOS-ArchitectureDemo
//
//  Created by Lingye Han on 2021/3/5.
//

import UIKit
import RxSwift

/**
 Sample iOS app written the way I write iOS apps because I cannot share the app I currently work on.

 https://blog.kulman.sk/architecting-ios-apps-coordinators/
 
 https://github.com/igorkulman/iOSSampleApp
 
 https://juejin.cn/post/6923197105422991367
 https://github.com/MarcoSantarossa/MVVM-C_with_Swift
 */
class AppCoordinator: BaseCoordinator<Void> {

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    override func start() -> Observable<Void> {
        let repositoryListCoordinator = RepositoryListCoordinator(window: window)
        return coordinate(to: repositoryListCoordinator)
    }
}
