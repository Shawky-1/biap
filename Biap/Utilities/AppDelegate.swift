//
//  AppDelegate.swift
//  Biap
//
//  Created by Ahmed Shawky on 28/02/2023.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        IQKeyboardManager.shared.enable = true
        
        let defaults = UserDefaults.standard
        // Check if Walkthrough is completed
        defaults.setValue(true, forKey: "WalkthroughCompleted")
        if defaults.bool(forKey: "WalkthroughCompleted") {
            // Check if email exists
            if defaults.string(forKey: "email") != nil {
                let TabBarVC = CustomTabbarVC()
                window?.rootViewController = TabBarVC
            } else {
                let loginVC = LoginVC()
                let navController = UINavigationController(rootViewController: loginVC)

                window?.rootViewController = navController
            }
        } else {
            let walkthroughVC = LoginVC() // Instantiate your WalkthroughVC here
            let navController = UINavigationController(rootViewController: walkthroughVC)
            window?.rootViewController = navController
        }
        
        window?.makeKeyAndVisible()
        return true
    }

}

