//
//  UserData.swift
//  SchoolLibrary
//
//  Created by Radi on 3.12.22.
//

import Foundation

final class UserData {
    
    static var email: String? {
        get {
            return UserDefaults.standard.string(forKey: "email")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "email")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var password: String? {
        get {
            return UserDefaults.standard.string(forKey: "password")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "password")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var userID: String? {
        get {
            return UserDefaults.standard.string(forKey: "userID")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userID")
            UserDefaults.standard.synchronize()
        }
    }
}
