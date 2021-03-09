//
//  RootRouter.swift
//  iOS-ArchitectureDemo
//
//  Created by Lingye Han on 2021/3/8.
//

import Foundation
import UIKit

class RootRouter {
    
    func presentMainScreen(in window: UIWindow?) {
        
        window?.rootViewController = RepoListRouter.assembleModule()
    }
}
