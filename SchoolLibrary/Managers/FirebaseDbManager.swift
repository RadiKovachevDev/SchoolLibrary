//
//  FirebaseDbManager.swift
//  SchoolLibrary
//
//  Created by Radi on 29.12.22.
//

import Foundation
import Firebase

final class FirebaseDbManager {
    static var db: DatabaseReference = {
        return Database.database().reference()
    }()
    
    static func create(user: User, completion: () -> Void)  {
        self.db.child("Users").child("\(user.uid )").setValue([
            "userDetails" : [
                "uid": user.uid,
                "firstName" : user.firstName,
                "lastName" : user.lastName,
                "email" : user.email,
                "phoneNumber" : user.phoneNumber
            ]
        ])
        completion()
    }
    
    static func login(user: User, completion: () -> Void)  {
        self.db.child("Users").child("\(user.uid)").observe(.childAdded, with: { snapshot in
            if let dict = snapshot.value as? [String:Any],
               let firstName = dict["firstName"] as? String,
               let lastName = dict["lastName"] as? String,
               let phoneNumber = dict["phoneNumber"] as? String {
                UserData.user?.firstName = firstName
                UserData.user?.lastName = lastName
                UserData.user?.phoneNumber = phoneNumber
            }
        })
        completion()
    }
    
    static func create(book: Book, completion: () -> Void) {
        self.db.child("Books").child("\(book.id)").setValue([
            "bookDetails" : [
                "id": book.id,
                "bookName" : book.name,
                "bookAuthor" : book.author,
                "shortDiscription" : book.shortDiscription,
                "longDiscription" : book.longDiscription,
                "publisher": book.publisher,
                "image" : "defoult_category_image",
                "category": book.category,
                "providedByUserID": book.providedByUserID,
                "takenOfUserID": "",
                "isAvalible": true,
                "bookReturnData": ""
            ]
        ])
        completion()
    }
}
