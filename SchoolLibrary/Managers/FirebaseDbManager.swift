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
    
    static var books = [Book]()
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
    
    static func login(user: User, completion: @escaping () -> Void) {
        self.db.child("Users").child("\(user.uid)").observe(.childAdded, with: { snapshot in
            if let dict = snapshot.value as? [String:Any],
               let firstName = dict["firstName"] as? String,
               let lastName = dict["lastName"] as? String,
               let phoneNumber = dict["phoneNumber"] as? String {
                UserData.user?.firstName = firstName
                UserData.user?.lastName = lastName
                UserData.user?.phoneNumber = phoneNumber
            }
            completion()
        })
    }
    
    static func fetchUserBy(userID: String, completion: @escaping (_ user: User?) -> Void) {
        self.db.child("Users").child(userID).observe(.childAdded, with: { snapshot in
            if let dict = snapshot.value as? [String:Any],
               let uid = dict["uid"] as? String,
               let email = dict["email"] as? String,
               let firstName = dict["firstName"] as? String,
               let lastName = dict["lastName"] as? String,
               let phoneNumber = dict["phoneNumber"] as? String {
                
                
               let user = User(uid: uid, email: email, password: "", firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
                completion(user)
            }
            completion(nil)
        })
    }
    
    static func create(book: Book, completion: @escaping () -> Void) {
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
    
    static func fetchBooks() {
        self.db.child("Books").getData(completion:  { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            if let books = snapshot?.value as? [String:Any] {
                for book in books {
                    guard let bookValue = book.value as? [String:Any],
                          let bookDetails = bookValue["bookDetails"] as? [String:Any],
                          let id = bookDetails["id"] as? String,
                          let bookName = bookDetails["bookName"] as? String,
                          let bookAuthor = bookDetails["bookAuthor"] as? String,
                          let shortDiscription = bookDetails["shortDiscription"] as? String,
                          let longDiscription = bookDetails["longDiscription"] as? String,
                          let publisher = bookDetails["publisher"] as? String,
                          let category = bookDetails["category"] as? String,
                          let providedByUserID = bookDetails["providedByUserID"] as? String,
                          let takenOfUserID = bookDetails["takenOfUserID"] as? String,
                          let isAvalible = bookDetails["isAvalible"] as? Bool,
                          let bookReturnData = bookDetails["bookReturnData"] as? String else {
                        continue
                    }
                    
                    
                    let currentBook = Book(id: id, name: bookName, author: bookAuthor, shortDiscription: shortDiscription, longDiscription: longDiscription, publisher: publisher, image: "defoult_category_image", category: category, providedByUserID: providedByUserID, takenOfUserID: takenOfUserID, isAvalible: isAvalible, bookReturnData: bookReturnData)
                    
                    if !self.books.contains(where: {$0.id == currentBook.id}) {
                        self.books.append(currentBook)
                    }
                }
            }
        });
    }
}
