//
//  BookDetailsViewController.swift
//  SchoolLibrary
//
//  Created by Radi on 3.12.22.
//

import UIKit

class BookDetailsViewController: UIViewController {

    var book: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension BookDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let currentBook = self.book,
              let providedUser = FakeDB.users.first(where: {$0.uid == currentBook.providedByUserID}) else {
            return UITableViewCell()
        }
        
        switch indexPath.row {
        case 0:
            if let imageCell = tableView.dequeueReusableCell(withIdentifier: "BookDetailsImageTableViewCell", for: indexPath) as? BookDetailsImageTableViewCell {
                return imageCell
            }
        case 5:
            if let providedByCell = tableView.dequeueReusableCell(withIdentifier: "BookDetailsProvidedByTableViewCell", for: indexPath) as? BookDetailsProvidedByTableViewCell {
                providedByCell.phoneNumber = providedUser.phoneNumber
                providedByCell.mail = providedUser.email
                providedByCell.userNameLabel.text = "\(providedUser.firstName) \(providedUser.lastName)"
                return providedByCell
            }
        default:
            if let descriptionCell = tableView.dequeueReusableCell(withIdentifier: "BookDetailsDescriptionTableViewCell", for: indexPath) as? BookDetailsDescriptionTableViewCell {
                switch indexPath.row {
                case 1:
                    descriptionCell.descriptionLabel.text = currentBook.name
                case 2:
                    descriptionCell.descriptionLabel.text = currentBook.longDiscription
                case 3:
                    descriptionCell.descriptionLabel.text = currentBook.author
                case 4:
                    descriptionCell.descriptionLabel.text = currentBook.publisher
                default:
                    break
                }
                
                return descriptionCell
            }
         }
        return UITableViewCell()
    }
    
    
}
