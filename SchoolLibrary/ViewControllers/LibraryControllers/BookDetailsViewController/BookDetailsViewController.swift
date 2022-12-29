//
//  BookDetailsViewController.swift
//  SchoolLibrary
//
//  Created by Radi on 3.12.22.
//

import UIKit

class BookDetailsViewController: UIViewController {

    var book: Book?
    var providedUser: User?
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
              let providedUser = self.providedUser else {
            return UITableViewCell()
        }
        
        switch indexPath.row {
        case 0:
            if let imageCell = tableView.dequeueReusableCell(withIdentifier: "BookDetailsImageTableViewCell", for: indexPath) as? BookDetailsImageTableViewCell {
                return imageCell
            }
        case 5:
            if let providedByCell = tableView.dequeueReusableCell(withIdentifier: "BookDetailsProvidedByTableViewCell", for: indexPath) as? BookDetailsProvidedByTableViewCell {
                providedByCell.userNameLabel.text = "\(providedUser.firstName) \(providedUser.lastName)"
                providedByCell.screenType = screenType
                providedByCell.primaryButton.setTitle("Call", for: .normal)
                providedByCell.secondaryButton.setTitle("Send mail", for: .normal)
                providedByCell.phoneNumber = providedUser.phoneNumber
                providedByCell.mail = providedUser.email
                providedByCell.generateQRCode.isHidden = true
                switch self.screenType {
                case .standartScreen:
                    providedByCell.generateQRCode.isHidden = true
                case .fromProvided:
                    providedByCell.generateQRCode.setTitle("QR provided book", for: .normal)
                    providedByCell.generateQRCode.isHidden = false
                case .fromTaken:
                    providedByCell.generateQRCode.setTitle("QR return book", for: .normal)
                    providedByCell.generateQRCode.isHidden = false
                }
                
                providedByCell.generateQRClicked = {[weak self] in
                    switch self?.screenType {
                    case .fromProvided:
                        if let qrUIImage = QRGenerator.generateQRCode(from: "Generate QR code for provided"),
                           let qrViewController = UIStoryboard.myBooks.instantiateViewController(withIdentifier: "QRViewController") as? QRViewController {
                            qrViewController.operationDescription = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."
                            qrViewController.generatedQRUIImage = qrUIImage
                            self?.present(qrViewController, animated: true, completion: nil)
                        }
                    case .fromTaken:
                        if let qrUIImage = QRGenerator.generateQRCode(from: "Generate QR code for taken"),
                           let qrViewController = UIStoryboard.myBooks.instantiateViewController(withIdentifier: "QRViewController") as? QRViewController {
                            qrViewController.operationDescription = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."
                            qrViewController.generatedQRUIImage = qrUIImage
                            self?.present(qrViewController, animated: true, completion: nil)
                        }
                    default:
                        break
                    }
                }
                
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
