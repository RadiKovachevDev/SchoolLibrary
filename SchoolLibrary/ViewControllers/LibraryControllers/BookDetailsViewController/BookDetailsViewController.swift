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
        6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let currentBook = self.book,
              let bookInUser = self.bookInUser else {
            return UITableViewCell()
        }
        
        switch indexPath.row {
        case 0:
            if let imageCell = tableView.dequeueReusableCell(withIdentifier: "BookDetailsImageTableViewCell", for: indexPath) as? BookDetailsImageTableViewCell {
                return imageCell
            }
        case 5:
            if let bookDetailsCell = tableView.dequeueReusableCell(withIdentifier: "BookDetailsProvidedByTableViewCell", for: indexPath) as? BookDetailsProvidedByTableViewCell {
                bookDetailsCell.providedByLabel.text = "Provided by"
                bookDetailsCell.userNameLabel.text = "\(bookInUser.firstName) \(bookInUser.lastName)"
                bookDetailsCell.primaryButton.setTitle("Call", for: .normal)
                bookDetailsCell.secondaryButton.setTitle("Send mail", for: .normal)
                bookDetailsCell.phoneNumber = bookInUser.phoneNumber
                bookDetailsCell.mail = bookInUser.email
                bookDetailsCell.generateQRCode.isHidden = true
                switch self.screenType {
                case .standartScreen:
                    bookDetailsCell.generateQRCode.isHidden = true
                case .fromProvided:
                    bookDetailsCell.generateQRCode.setTitle("QR provided book", for: .normal)
                    bookDetailsCell.generateQRCode.isHidden = false
                    bookDetailsCell.providedByLabel.text = "Taken by"
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
                    bookDetailsCell.generateQRCode.setTitle("QR return book", for: .normal)
                    bookDetailsCell.generateQRCode.isHidden = false
                }
                
                bookDetailsCell.generateQRClicked = {[weak self] in
                    switch self?.screenType {
                    case .fromProvided:
                        if let qrUIImage = QRGenerator.generateQRCode(from: currentBook.id),
                           let qrViewController = UIStoryboard.myBooks.instantiateViewController(withIdentifier: "QRViewController") as? QRViewController {
                            qrViewController.operationDescription = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."
                            qrViewController.generatedQRUIImage = qrUIImage
                            self?.present(qrViewController, animated: true, completion: nil)
                        }
                    case .fromTaken:
                        if let qrUIImage = QRGenerator.generateQRCode(from: currentBook.id),
                           let qrViewController = UIStoryboard.myBooks.instantiateViewController(withIdentifier: "QRViewController") as? QRViewController {
                            qrViewController.operationDescription = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."
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
