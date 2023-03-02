//
//  CustomTabbarVC.swift
//  Biap
//
//  Created by Ahmed Shawky on 02/03/2023.
//

import UIKit

class CustomTabbarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create instance of view controllers
        let homeNC = UINavigationController(rootViewController: HomeVC())
        homeNC.title = "Home"
        let recordsNC = UINavigationController(rootViewController: HomeVC())
        recordsNC.title = "Home"
        let visitsNC = UINavigationController(rootViewController: HomeVC())
        visitsNC.title = "Home"
        let profileNC = UINavigationController(rootViewController: HomeVC())
        profileNC.title = "Home"

        // Assign view controllers to tab bar
        let tabBarList = [homeNC, recordsNC, visitsNC, profileNC]
        self.setViewControllers(tabBarList, animated: false)
        
        guard let items = self.tabBar.items else { return }
        let images = ["home", "home", "home", "home"]
        for x in 0...3 {
            items[x].image = UIImage(systemName: images[x])
        }
        
        if let items = self.tabBar.items {
          items.forEach { item in item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0) }
        }

        self.tabBar.itemWidth = tabBar.frame.width / 7.0
        self.tabBar.itemPositioning = .centered
    }
    

}
