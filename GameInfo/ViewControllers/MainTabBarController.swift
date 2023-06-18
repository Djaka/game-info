//
//  MainTabBarController.swift
//  GameInfo
//
//  Created by Djaka Permana on 03/06/23.
//

import UIKit

class MainTabBarController: UITabBarController {

    let mainViewController = MainViewController()
    let favoriteViewController = FavoriteGameViewController()
    let profileViewController = ProfileViewController()
    
    var customTabBarView = UIView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarUI()
        addCustomTabBarView()

        mainViewController.tabBarItem = UITabBarItem(title: "Games", image: UIImage(systemName: "gamecontroller"), tag: 0)
        mainViewController.tabBarItem.selectedImage = UIImage(systemName: "gamecontroller.fill")
        favoriteViewController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart"), tag: 0)
        favoriteViewController.tabBarItem.selectedImage = UIImage(systemName: "heart.fill")
        profileViewController.tabBarItem = UITabBarItem(title: "About", image: UIImage(systemName: "person"), tag: 1)
        profileViewController.tabBarItem.selectedImage = UIImage(systemName: "person.fill")
        
        viewControllers = [mainViewController, favoriteViewController, profileViewController]
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupCustomTabBarFrame()
    }
    
    private func setupCustomTabBarFrame() {
            let height = self.view.safeAreaInsets.bottom + 64
            
            var tabFrame = self.tabBar.frame
            tabFrame.size.height = height
            tabFrame.origin.y = self.view.frame.size.height - height
            
            self.tabBar.frame = tabFrame
            self.tabBar.setNeedsLayout()
            self.tabBar.layoutIfNeeded()
            customTabBarView.frame = tabBar.frame
        }
    
    private func setupTabBarUI() {
        self.tabBar.layer.cornerRadius = 40
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.tabBar.tintColor = UIColor(hex: "#18122B")
        self.tabBar.unselectedItemTintColor = UIColor(hex: "#635985")
        self.tabBar.backgroundColor = UIColor(hex: "#ffffff")
            
        if #available(iOS 13.0, *) {
            let appearance = self.tabBar.standardAppearance
            appearance.shadowImage = nil
            appearance.shadowColor = nil
            self.tabBar.standardAppearance = appearance
        } else {
            self.tabBar.shadowImage = UIImage()
            self.tabBar.backgroundImage = UIImage()
        }
    }
    
    private func addCustomTabBarView() {
        self.customTabBarView.frame = tabBar.frame
        
        self.customTabBarView.backgroundColor = UIColor(hex: "#ffffff")
        self.customTabBarView.layer.cornerRadius = 40
        self.customTabBarView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        self.customTabBarView.layer.masksToBounds = false
        self.customTabBarView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.customTabBarView.layer.shadowOffset = CGSize(width: -4, height: -6)
        self.customTabBarView.layer.shadowOpacity = 0.5
        self.customTabBarView.layer.shadowRadius = 20
        
        self.view.addSubview(customTabBarView)
        self.view.bringSubviewToFront(self.tabBar)
    }

}
