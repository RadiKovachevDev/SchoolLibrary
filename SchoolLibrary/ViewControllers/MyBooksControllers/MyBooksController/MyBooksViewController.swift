//
//  ProvidedViewController.swift
//  SchoolLibrary
//
//  Created by Radi on 1.12.22.
//

import UIKit

class MyBooksViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var myBooksSegment: UISegmentedControl!
    @IBOutlet weak var actionButton: UIButton!
    
    var screenType: MyBooksScreenType = .taken
    var myBooks: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
    }
    
    func setupScreen() {
        switch screenType {
        case .taken:
            myBooks = FakeDB.books.filter({$0.takenOfUserID == "idkng"})
        case .provided:
            myBooks = FakeDB.books.filter({$0.providedByUserID == "idkng"})
        }
        self.tableView.reloadData()
    }
    
    @IBAction func changeSegmentState(_ sender: UISegmentedControl) {
        switch myBooksSegment.selectedSegmentIndex {
        case 1:
            self.screenType = .provided
            self.actionButton.setTitle("Add new book to provide", for: .normal)
        default:
            self.screenType = .taken
            self.actionButton.setTitle("Scan book QR", for: .normal)
        }
        setupScreen()
    }
    
    @IBAction func actionButtonTaped(_ sender: UIButton) {
        switch screenType {
        case .taken:
            print("Scaned QR code")
        case .provided:
            print("Added new book")
        }
    }
}

extension MyBooksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let bookCell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell", for: indexPath) as? BookTableViewCell {
            let currentBook = myBooks[indexPath.row]
            bookCell.bookNameLabel.text = currentBook.name
            bookCell.smallDescriptionLabel.text = currentBook.shortDiscription
            bookCell.publisherLabel.text = currentBook.publisher
            bookCell.authorLabel.text = currentBook.author
            return bookCell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let bookDetailsViewController = UIStoryboard.library.instantiateViewController(withIdentifier: "BookDetailsViewController") as? BookDetailsViewController {
            bookDetailsViewController.book = myBooks[indexPath.row]
            self.navigationController?.pushViewController(bookDetailsViewController, animated: true)
        }
    }
    
    
}
