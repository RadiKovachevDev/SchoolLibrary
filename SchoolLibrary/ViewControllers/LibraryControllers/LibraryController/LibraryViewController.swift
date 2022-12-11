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
        self.categories = FakeDB.categories
        self.books = FakeDB.books
        filteredBooksByCategory()
    }
    
    func filteredBooksByCategory() {
        self.filteredBooks =  self.currentCategory == .all ? self.books : self.books.filter({Category(rawValue: $0.category) == self.currentCategory})
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
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
        self.filteredBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let bookCell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell", for: indexPath) as? BookTableViewCell {
            let currentBook = self.filteredBooks[indexPath.row]
            bookCell.authorLabel.text = currentBook.author
            bookCell.bookNameLabel.text = currentBook.name
            bookCell.publisherLabel.text = currentBook.publisher
            bookCell.smallDescriptionLabel.text = currentBook.shortDiscription
            return bookCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let bookDetailsViewController = UIStoryboard.library.instantiateViewController(withIdentifier: "BookDetailsViewController") as? BookDetailsViewController {
            bookDetailsViewController.book = self.filteredBooks[indexPath.row]
            self.navigationController?.pushViewController(bookDetailsViewController, animated: true)
        }
    }
}
