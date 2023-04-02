//
//  BookDetailsViewController.swift
//  SchoolLibrary
//
//  Created by Radi on 3.12.22.
//

import UIKit

class BookDetailsViewController: UIViewController {

    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var providedByLabel: UILabel!
    @IBOutlet weak var providedByTitle: UILabel!
    @IBOutlet weak var primaryButton: UIButton!
    @IBOutlet weak var secondaryButton: UIButton!
    @IBOutlet weak var generateQRCode: UIButton!
    
    var book: Book?
    var bookInUser: User?
    var screenType: BookScreenType = .standartScreen
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttonsView.layer.cornerRadius = 16
        self.buttonsView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupScreen()
    }
    
    @IBAction func secondaryButtonTapped(_ sender: Any) {
        guard let bookInUser = self.bookInUser else {
            return
        }
        
        if screenType == .fromProvided && book?.takenOfUserID == "" {
            guard let deleteBook = self.book else { return }
            var actions: [(String, UIAlertAction.Style)] = []
            actions.append(("delete_book_title".localized, .default))
            actions.append(("cancel_global_title".localized, .cancel))
            Alerts.showActionsheet(viewController: self, title: "delete_book_title".localized, message: "are_you_sure_you_want_to_delete_the_book".localized, actions: actions, completion: {index in
                switch index {
                case 0:
                    FirebaseDbManager.delete(book: deleteBook, completion: {
                        FirebaseDbManager.books.removeAll(where: {$0.id == deleteBook.id})
                        self.navigationController?.popViewController(animated: true)
                    })
                default:
                    break
                }
            })
        } else {
            if let url = URL(string:  "mailto:\(bookInUser.email)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func primaryButtonTapped(_ sender: Any) {
        guard let bookInUser = self.bookInUser else {
            return
        }
        
        if screenType == .fromProvided && book?.takenOfUserID == "" {
            guard let book = self.book else { return }
            var actions: [(String, UIAlertAction.Style)] = []
            actions.append((book.isAvalible == true ?"stop_providing_the_book_title".localized : "start_providing_the_book".localized, .default))
            actions.append(("cancel_global_title".localized, .cancel))
            Alerts.showActionsheet(viewController: self,
                                   title: book.isAvalible == true ? "stop_providing_the_book_title".localized : "start_providing_the_book".localized,
                                   message: book.isAvalible == true ?  "are_you_sure_you_want_to_stop_providing_the_book".localized : "are_you_sure_you_want_to_start_providing_the_book".localized,
                                   actions: actions, completion: {index in
                switch index {
                case 0:
                    var modifyBook = book
                    modifyBook.isAvalible = !modifyBook.isAvalible
                    FirebaseDbManager.create(book: modifyBook, completion: {
                        self.navigationController?.popViewController(animated: true)
                    })
                default:
                    break
                }
            })
        } else {
            if let url = URL(string: "tel://\(bookInUser.phoneNumber)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func generateQRCodeButtonTapped(_ sender: Any) {
        guard let currentBook = self.book else {
            return
        }
        switch self.screenType {
        case .fromProvided:
            if let qrUIImage = QRGenerator.generateQRCode(from: currentBook.id),
               let qrViewController = UIStoryboard.myBooks.instantiateViewController(withIdentifier: "QRViewController") as? QRViewController {
                qrViewController.operationDescription = "qr_code_exchange_provided".localized
                qrViewController.generatedQRUIImage = qrUIImage
                self.present(qrViewController, animated: true, completion: nil)
            }
        case .fromTaken:
            if let qrUIImage = QRGenerator.generateQRCode(from: currentBook.id),
               let qrViewController = UIStoryboard.myBooks.instantiateViewController(withIdentifier: "QRViewController") as? QRViewController {
                qrViewController.operationDescription = "qr_code_exchange_taken".localized
                qrViewController.generatedQRUIImage = qrUIImage
                self.present(qrViewController, animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    func setupScreen() {
        guard let bookInUser = self.bookInUser else {
            return
        }
        
        self.providedByLabel.text = "provided_by_label".localized
        self.providedByLabel.text = "\(bookInUser.firstName) \(bookInUser.lastName)"
        self.primaryButton.setTitle("call_title".localized, for: .normal)
        self.secondaryButton.setTitle("send_mail_title".localized, for: .normal)
        self.generateQRCode.isHidden = true
        switch self.screenType {
        case .standartScreen:
            self.generateQRCode.isHidden = true
        case .fromProvided:
            self.generateQRCode.setTitle("provided_book_qr".localized, for: .normal)
            self.generateQRCode.isHidden = false
            self.providedByLabel.text = "taken_by".localized
            if book?.takenOfUserID == "" {
                self.providedByLabel.isHidden = true
                self.providedByTitle.isHidden = true
                self.primaryButton.setTitle(book?.isAvalible == true ? "stop_providing".localized : "start_providing".localized, for: .normal)
                self.primaryButton.isHidden = false
                self.secondaryButton.setTitle("click_to_delete_the_book".localized, for: .normal)
                if screenType == .fromProvided && book?.isAvalible == false {
                    
                }
                self.secondaryButton.isHidden = false
                self.generateQRCode.isHidden = false
            } else {
                self.primaryButton.isHidden = false
                self.secondaryButton.isHidden = false
                self.generateQRCode.isHidden = true
            }
        case .fromTaken:
            self.generateQRCode.setTitle("return_book_qr".localized, for: .normal)
            self.generateQRCode.isHidden = false
        }
    }
}

extension BookDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let currentBook = self.book else {
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
        default:
            return UITableViewCell()
         }
        return UITableViewCell()
    }
    
    
}
