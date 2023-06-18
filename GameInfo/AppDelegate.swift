//
//  AppDelegate.swift
//  GameInfo
//
//  Created by Djaka Permana on 02/06/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        
        if !AboutPreference.loadFirstDefault {
            
            if let data = loadJson(filename: "About"),
               let image = data.authorImage,
               let author = data.author,
               let email = data.email,
               let currentJob = data.currentJob,
               let description = data.description {
                
                AboutPreference.imageProfileDefault = image
                AboutPreference.authorDefault = author
                AboutPreference.emailDefault = email
                AboutPreference.currentJobDefault = currentJob
                AboutPreference.descriptionDefault = description
                
                AboutPreference.loadFirstDefault = true
            }
        }
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    private func loadJson(filename fileName: String) -> About? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ResponseData.self, from: data)
                return jsonData.about
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
}
