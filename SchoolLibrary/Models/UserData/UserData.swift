//
//  UserData.swift
//  SchoolLibrary
//
//  Created by Radi on 3.12.22.
//

import Foundation

final class UserData {
    static var user: User? {
        get {
            if let data = UserDefaults.standard.data(forKey: "user") {
                do {
                    let decoder = JSONDecoder()
                    let user = try decoder.decode(User.self, from: data)
                    return user
                } catch {
                    print("Unable to Decode Note (\(error))")
                }
            }
            return nil
        }
        set {
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(newValue)
                UserDefaults.standard.set(data, forKey: "user")
                UserDefaults.standard.synchronize()
            } catch {
                print("Unable to Encode Note (\(error))")
            }
        }
    }
    static var selectedLanguage: String? {
            get {
                return UserDefaults.standard.string(forKey: "selectedLanguage")
            }
            set {
                UserDefaults.standard.set(newValue, forKey: "selectedLanguage")
                UserDefaults.standard.synchronize()
            }
        }
}
