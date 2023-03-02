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
        
//        UINavigationBar.appearance().barTintColor = .black
//        UINavigationBar.appearance().tintColor = .white
//        UINavigationBar.appearance().isTranslucent = false
        
       // SET THE ROOT VIEW CONTROLLER
//        window = UIWindow(frame: UIScreen.main.bounds)
//        let HomeVC = HomeVC(nibName: "HomeVC", bundle: nil)
//        let navController = UINavigationController(rootViewController: HomeVC)
////
//        window?.rootViewController = navController


        window?.rootViewController = CustomTabbarVC()
        window?.makeKeyAndVisible()
        
        return true
    }

}

