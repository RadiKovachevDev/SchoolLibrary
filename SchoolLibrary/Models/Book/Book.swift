//
//  Book.swift
//  SchoolLibrary
//
//  Created by Radi on 10.12.22.
//

import Foundation
import Firebase

struct Book: Codable {
    var id: String
    var name: String
    var author: String
    var shortDiscription: String
    var longDiscription: String
    var publisher: String
    var image: String
    var category: String
    var providedByUserID: String
    var takenOfUserID: String
    var isAvalible: Bool
    var bookReturnData: String
    
    init(id: String, name: String, author: String, shortDiscription: String, longDiscription: String, publisher: String, image: String, category: String, providedByUserID: String, takenOfUserID: String, isAvalible: Bool, bookReturnData: String) {
        self.id = id
        self.name = name
        self.author = author
        self.shortDiscription = shortDiscription
        self.longDiscription = longDiscription
        self.publisher = publisher
        self.image = image
        self.category = category
        self.providedByUserID = providedByUserID
        self.takenOfUserID = takenOfUserID
        self.isAvalible = isAvalible
        self.bookReturnData = bookReturnData
    }
}
