//
//  LibraryViewController.swift
//  SchoolLibrary
//
//  Created by Radi on 1.12.22.
//

import UIKit

class LibraryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var categories = [Category]()
    var books = [Book]()
    var filteredBooks = [Book]()
    var currentCategory: Category = .all
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categories = Category.allCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FirebaseDbManager.fetchBooks(completion: {
            self.books = FirebaseDbManager.books
            self.filteredBooksByCategory()
            self.tableView.reloadData()
        })
    }
    
    func filteredBooksByCategory() {
        self.filteredBooks =  self.currentCategory == .all ? self.books.filter({$0.takenOfUserID == ""}) : self.books.filter({Category(rawValue: $0.category) == self.currentCategory && $0.takenOfUserID == ""})
    }
}

extension LibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let categoryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell {
            categoryCollectionViewCell.categoryName.text = self.categories[indexPath.row].rawValue
            return categoryCollectionViewCell
            
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currentCategory = categories[indexPath.row]
        self.filteredBooksByCategory()
        self.tableView.reloadData()
    }
}
extension LibraryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredBooks.count == 0 {
            return 1
        } else {
            return filteredBooks.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if filteredBooks.count == 0 {
            if let noBooksCell = tableView.dequeueReusableCell(withIdentifier: "NoBooksTableViewCell", for: indexPath) as? NoBooksTableViewCell {
                
                switch currentCategory {
                case .all:
                    noBooksCell.titleLabel.text = "There are no books in library"
                    noBooksCell.descriptionLabel.text = "You can be the first one to add a book"
                default:
                    noBooksCell.titleLabel.text = "There are no books in \(currentCategory.rawValue)"
                    noBooksCell.descriptionLabel.text = "You can be the first one to add a book in \(currentCategory.rawValue) category"
                    break;
                }
                
                
                return noBooksCell
            }
        } else {
            if let bookCell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell", for: indexPath) as? BookTableViewCell {
                let currentBook = self.filteredBooks[indexPath.row]
                bookCell.authorLabel.text = currentBook.author
                bookCell.bookNameLabel.text = currentBook.name
                bookCell.publisherLabel.text = currentBook.publisher
                bookCell.smallDescriptionLabel.text = currentBook.shortDiscription
                return bookCell
            }
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if filteredBooks.count == 0 {
            
        } else {
            if let bookDetailsViewController = UIStoryboard.library.instantiateViewController(withIdentifier: "BookDetailsViewController") as? BookDetailsViewController {
                bookDetailsViewController.screenType = .standartScreen
                bookDetailsViewController.book = self.filteredBooks[indexPath.row]
                FirebaseDbManager.fetchUserBy(userID: self.filteredBooks[indexPath.row].providedByUserID, completion: {user in
                    if let providedUser = user {
                        bookDetailsViewController.bookInUser = providedUser
                        self.navigationController?.pushViewController(bookDetailsViewController, animated: true)
                    }
                })
            }
            
        }
    }
}
