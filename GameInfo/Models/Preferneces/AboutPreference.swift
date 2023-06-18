//
//  AboutPreference.swift
//  GameInfo
//
//  Created by Djaka Permana on 18/06/23.
//

import Foundation

struct AboutPreference {
    static let loadFirstKey = "loadFirst"
    static let imageProfileKey = "image_profile"
    static let authorKey = "author"
    static let currentJobKey = "current_jon"
    static let emailKey = "email"
    static let descriptionKey = "description"
    
    static var loadFirstDefault: Bool {
        get {
            return UserDefaults.standard.bool(forKey: loadFirstKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: loadFirstKey)
        }
    }
    
    static var imageProfileDefault: String {
        get {
            return UserDefaults.standard.string(forKey: imageProfileKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: imageProfileKey)
        }
    }
    
    static var authorDefault: String {
        get {
            return UserDefaults.standard.string(forKey: authorKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: authorKey)
        }
    }
    
    static var emailDefault: String {
        get {
            return UserDefaults.standard.string(forKey: emailKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: emailKey)
        }
    }
    
    static var currentJobDefault: String {
        get {
            return UserDefaults.standard.string(forKey: currentJobKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: currentJobKey)
        }
    }
    
    static var descriptionDefault: String {
        get {
            return UserDefaults.standard.string(forKey: descriptionKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: descriptionKey)
        }
    }
    
    static func deleteAll() -> Bool {
        if let domain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: domain)
            syncronize()
            return true
        } else {
            return false
        }
    }
    
    static func syncronize() {
        UserDefaults.standard.synchronize()
    }
}
