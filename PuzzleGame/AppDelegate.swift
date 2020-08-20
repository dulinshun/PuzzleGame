//
//  AppDelegate.swift
//  PuzzleGame
//
//  Created by top on 2020/8/20.
//  Copyright © 2020 top. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.frame = UIScreen.main.bounds
        window?.makeKeyAndVisible()
        window?.backgroundColor = .white
        
        let rootController = UINavigationController(rootViewController: HomeController())
        window?.rootViewController = rootController
        return true
    }
}

