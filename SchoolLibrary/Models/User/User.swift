//
//  User.swift
//  SchoolLibrary
//
//  Created by Radi on 10.12.22.
//

import Foundation

struct User: Codable {
    var uid: String
    var email: String
    var password: String
    var firstName: String
    var lastName: String
    var phoneNumber: String
}
