//
//  MainTabBarController.swift
//  GameInfo
//
//  Created by Djaka Permana on 03/06/23.
//

import UIKit

class MainTabBarController: UITabBarController {

    let mainViewController = MainViewController()
    let profileViewController = ProfileViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainViewController.tabBarItem = UITabBarItem(title: "Games", image: UIImage(systemName: "gamecontroller"), tag: 0)
        mainViewController.tabBarItem.selectedImage = UIImage(systemName: "gamecontroller.fill")
        profileViewController.tabBarItem = UITabBarItem(title: "About", image: UIImage(systemName: "person"), tag: 1)
        profileViewController.tabBarItem.selectedImage = UIImage(systemName: "person.fill")
        
        viewControllers = [mainViewController, profileViewController]
        
        self.tabBar.tintColor = UIColor(hex: "#18122B")
        self.tabBar.unselectedItemTintColor = UIColor(hex: "#635985")
        self.tabBar.backgroundColor = UIColor(hex: "#eff0f0")
    }

}
