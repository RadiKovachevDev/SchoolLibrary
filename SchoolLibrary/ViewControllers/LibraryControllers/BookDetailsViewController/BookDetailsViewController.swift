//
//  BookDetailsViewController.swift
//  SchoolLibrary
//
//  Created by Radi on 3.12.22.
//

import UIKit

class BookDetailsViewController: UIViewController {

    var book: Book?
    var bookInUser: User?
    var screenType: BookScreenType = .standartScreen
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension BookDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let currentBook = self.book,
              let bookInUser = self.bookInUser else {
            return UITableViewCell()
        }
        
        switch indexPath.row {
        case 0:
            if let imageCell = tableView.dequeueReusableCell(withIdentifier: "BookDetailsImageTableViewCell", for: indexPath) as? BookDetailsImageTableViewCell {
                if let category = Category(rawValue: currentBook.category) {
                    imageCell.categoryNameLabel.text = category.rawValue.localized
                }
                
                return imageCell
            }
        case 1:
            if let descriptionCell = tableView.dequeueReusableCell(withIdentifier: "BookDetailsDescriptionTableViewCell", for: indexPath) as? BookDetailsDescriptionTableViewCell {
                
                descriptionCell.authorLabel.text = "author_label".localized
                descriptionCell.publisherLabel.text = "publisher_label".localized
                descriptionCell.bookNameLabel.text = currentBook.name
                descriptionCell.longDiscriptionLabel.text = currentBook.longDiscription
                descriptionCell.authorNameLabel.text = currentBook.author
                descriptionCell.publisherNameLabel.text = currentBook.publisher
               
                return descriptionCell
            }
        case 2:
            if let bookDetailsCell = tableView.dequeueReusableCell(withIdentifier: "BookDetailsProvidedByTableViewCell", for: indexPath) as? BookDetailsProvidedByTableViewCell {
                bookDetailsCell.providedByLabel.text = "provided_by_label".localized
                bookDetailsCell.userNameLabel.text = "\(bookInUser.firstName) \(bookInUser.lastName)"
                bookDetailsCell.primaryButton.setTitle("call_title".localized, for: .normal)
                bookDetailsCell.secondaryButton.setTitle("send_mail_title".localized, for: .normal)
                bookDetailsCell.phoneNumber = bookInUser.phoneNumber
                bookDetailsCell.mail = bookInUser.email
                bookDetailsCell.generateQRCode.isHidden = true
                switch self.screenType {
                case .standartScreen:
                    bookDetailsCell.generateQRCode.isHidden = true
                case .fromProvided:
                    bookDetailsCell.generateQRCode.setTitle("provided_book_qr".localized, for: .normal)
                    bookDetailsCell.generateQRCode.isHidden = false
                    bookDetailsCell.providedByLabel.text = "taken_by".localized
                    if book?.takenOfUserID == "" {
                        bookDetailsCell.providedByLabel.isHidden = true
                        bookDetailsCell.userNameLabel.isHidden = true
                        bookDetailsCell.primaryButton.isHidden = true
                        bookDetailsCell.secondaryButton.isHidden = true
                        bookDetailsCell.generateQRCode.isHidden = false
                    } else {
                        bookDetailsCell.primaryButton.isHidden = false
                        bookDetailsCell.secondaryButton.isHidden = false
                        bookDetailsCell.generateQRCode.isHidden = true
                    }
                case .fromTaken:
                    bookDetailsCell.generateQRCode.setTitle("return_book_qr".localized, for: .normal)
                    bookDetailsCell.generateQRCode.isHidden = false
                }
                
                bookDetailsCell.generateQRClicked = {[weak self] in
                    switch self?.screenType {
                    case .fromProvided:
                        if let qrUIImage = QRGenerator.generateQRCode(from: currentBook.id),
                           let qrViewController = UIStoryboard.myBooks.instantiateViewController(withIdentifier: "QRViewController") as? QRViewController {
                            qrViewController.operationDescription = "qr_code_exchange_provided".localized
                            qrViewController.generatedQRUIImage = qrUIImage
                            self?.present(qrViewController, animated: true, completion: nil)
                        }
                    case .fromTaken:
                        if let qrUIImage = QRGenerator.generateQRCode(from: currentBook.id),
                           let qrViewController = UIStoryboard.myBooks.instantiateViewController(withIdentifier: "QRViewController") as? QRViewController {
                            qrViewController.operationDescription = "qr_code_exchange_taken".localized
                            qrViewController.generatedQRUIImage = qrUIImage
                            self?.present(qrViewController, animated: true, completion: nil)
                        }
                    default:
                        break
                    }
                }
                
                return bookDetailsCell
            }
        default:
            return UITableViewCell()
         }
        return UITableViewCell()
    }
    
    
}
