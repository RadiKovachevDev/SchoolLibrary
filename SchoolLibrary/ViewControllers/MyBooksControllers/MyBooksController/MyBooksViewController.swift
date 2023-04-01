//
//  ProvidedViewController.swift
//  SchoolLibrary
//
//  Created by Radi on 1.12.22.
//

import UIKit
import AVFoundation
import JGProgressHUD

class MyBooksViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var myBooksSegment: UISegmentedControl!
    @IBOutlet weak var segmentView: UIView!
    @IBOutlet weak var actionButton: UIButton!
    
    var screenType: MyBooksScreenType = .taken
    var myBooks: [Book] = []
    var myRightBarButtonItem = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTabBarTitles()
        self.myRightBarButtonItem = self.navigationItem.rightBarButtonItem ?? UIBarButtonItem()
        self.navigationItem.rightBarButtonItem = self.myRightBarButtonItem
        setupScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.segmentView.clipsToBounds = true
        self.segmentView.layer.cornerRadius = 16
        self.segmentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        FirebaseDbManager.fetchBooks {
            self.myRightBarButtonItem.title = "add_book".localized
            self.tableView.reloadData()
            self.setupScreen()
        }
    }
    
    func setupScreen() {
        guard let user = UserData.user else { return }
        myBooksSegment.setTitle("taken_segment_title".localized, forSegmentAt: 0)
        myBooksSegment.setTitle("provided_segment_title".localized, forSegmentAt: 1)
        self.title = "mybooks_title".localized
        switch screenType {
        case .taken:
            self.actionButton.setTitle("scan_book_for_taken_qr_button".localized, for: .normal)
            myBooks = FirebaseDbManager.books.filter({$0.takenOfUserID == user.uid})
            self.navigationItem.rightBarButtonItem = nil
        case .provided:
            self.actionButton.setTitle("scan_book_for_provided_qr_button".localized, for: .normal)
            myBooks = FirebaseDbManager.books.filter({$0.providedByUserID == user.uid})
            self.navigationItem.rightBarButtonItem = self.myRightBarButtonItem
        }
        self.tableView.reloadData()
    }
    
    @IBAction func changeSegmentState(_ sender: UISegmentedControl) {
        switch myBooksSegment.selectedSegmentIndex {
        case 1:
            self.screenType = .provided
        default:
            self.screenType = .taken
            
        }
        setupScreen()
    }
    
    @IBAction func actionButtonTaped(_ sender: UIButton) {
            openQRScanner()
    }
    
    @IBAction func addBookButtonTapped(_ sender: UIBarButtonItem) {
        if let createBookViewController = UIStoryboard.myBooks.instantiateViewController(withIdentifier: "CreateBookViewController") as? CreateBookViewController {
            self.navigationController?.pushViewController(createBookViewController, animated: true)
        }
    }
    
    func openQRScanner(){
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
                if response {
                    if let qRScannerViewController = UIStoryboard.myBooks.instantiateViewController(withIdentifier: "QRScannerViewController") as? QRScannerViewController{
                        qRScannerViewController.returnQRCode = { [weak self] qrCode in
                            DispatchQueue.main.async {
                                self?.handleQR(result: qrCode)
                            }
                        }
                        self.present(qRScannerViewController, animated: true)
                    }
                    
                } else {
                    var actions: [(String, UIAlertAction.Style)] = []
                    actions.append(("ok_global_title".localized, .cancel))
                    Alerts.showAlert(viewController: self, title: "camera_permission_title".localized, message: "camera_permission_discription".localized, actions: actions, completion: {index in
                        switch index {
                        default:
                            break
                        }
                    })
                }
            }
        case .restricted, .denied:
            var actions: [(String, UIAlertAction.Style)] = []
            actions.append(("ok_global_title".localized, .cancel))
            Alerts.showAlert(viewController: self, title: "camera_permission_title".localized, message: "camera_permission_discription".localized, actions: actions, completion: {index in
                switch index {
                default:
                    break
                }
            })
        case .authorized:
            if let qRScannerViewController = UIStoryboard.myBooks.instantiateViewController(withIdentifier: "QRScannerViewController") as? QRScannerViewController{
                qRScannerViewController.returnQRCode = { [weak self] qrCode in
                    DispatchQueue.main.async {
                        self?.handleQR(result: qrCode)
                    }
                }
                self.present(qRScannerViewController, animated: true)
            }
        @unknown default:
            print("default")
        }
    }

    func handleQR(result: String) {
        if result.isEmpty {
            showError(error: "error_global_title".localized, delay: 3.0, onDismiss: nil)
        } else {
            guard let book = FirebaseDbManager.books.first(where: {$0.id == result}),
                  let user = UserData.user else {
                showError(error: "there_isnt_a_book_with_that_qr_code".localized, delay: 3.0, onDismiss: nil)
                return
            }
            
            if (screenType == .taken && book.providedByUserID == user.uid) || (screenType == .provided && book.providedByUserID != user.uid ) {
                showError(error: "unauthorized_operation".localized, delay: 3.0, onDismiss: nil)
                return
            }
            
            var modifyBook = book
            
            var actions: [(String, UIAlertAction.Style)] = []
            
            switch screenType {
            case .taken:
                let timestamp = Date().timeIntervalSince1970
                let timestampReturn = Int(timestamp) + 2592000
                actions.append(("i_recieved_the_book_title".localized, .default))
                actions.append(("cancel_global_title".localized, .cancel))
                Alerts.showActionsheet(viewController: self, title: "taken_book".localized, message: "i_took_title".localized + " \(book.name)" + " return_date_title".localized + " \(timestampReturn.timestampToDate())", actions: actions, completion: {index in
                    switch index {
                    case 0:
                        modifyBook.takenOfUserID = user.uid
                        modifyBook.bookReturnData = "\(timestampReturn)"
                        FirebaseDbManager.create(book: modifyBook, completion: {
                            FirebaseDbManager.fetchBooks {
                                self.showMessage(message: "done_global_title".localized,delay: 3.0, onDismiss: {
                                    self.setupScreen()
                                })
                            }
                        })
                    default:
                        break
                    }
                })
            case .provided:
                actions.append(("my_book_was_returned".localized, .default))
                actions.append(("cancel_global_title".localized, .cancel))
                Alerts.showActionsheet(viewController: self, title: "done_global_title".localized, message: "i_have_received_my_book_back".localized, actions: actions, completion: {index in
                    switch index {
                    case 0:
                        modifyBook.takenOfUserID = ""
                        modifyBook.bookReturnData = ""
                        FirebaseDbManager.create(book: modifyBook, completion: {
                            FirebaseDbManager.fetchBooks {
                                self.showMessage(message: "done_global_title".localized, delay: 3.0, onDismiss: {
                                    self.setupScreen()
                                })
                            }
                        })
                    default:
                        break
                    }
                })
            }
        }
    }
}

extension MyBooksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if myBooks.count == 0 {
            return 1
        } else {
            return myBooks.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if myBooks.count == 0 {
            if let noBooksCell = tableView.dequeueReusableCell(withIdentifier: "NoBooksTableViewCell", for: indexPath) as? NoBooksTableViewCell {
                switch screenType {
                case .taken:
                    noBooksCell.titleLabel.text = "no_taken_books_title".localized
                    noBooksCell.descriptionLabel.text = "no_taken_books_discription".localized
                case .provided:
                    noBooksCell.titleLabel.text = "no_provided_books_title".localized
                    noBooksCell.descriptionLabel.text = "no_provided_books_discription".localized
                }
                
                return noBooksCell
            }
        } else {
            if let bookCell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell", for: indexPath) as? BookTableViewCell {
                let currentBook = myBooks[indexPath.row]
                bookCell.bookNameLabel.text = currentBook.name
                bookCell.smallDescriptionLabel.text = currentBook.shortDiscription
                bookCell.publisherLabel.text = currentBook.publisher
                bookCell.authorLabel.text = currentBook.author
                bookCell.categoryLabel.text = currentBook.category.localized
                
                let timestamp = Int(Date().timeIntervalSince1970)
                if timestamp > Int(currentBook.bookReturnData) ?? 0 && currentBook.takenOfUserID != "" {
                    bookCell.cellView.backgroundColor = UIColor(named: "slReturnedBackground")
                } else if screenType == .provided && currentBook.takenOfUserID != "" {
                    bookCell.cellView.backgroundColor = UIColor(named: "slTakenBookBackground")
                } else {
                    bookCell.cellView.backgroundColor = UIColor(named: "slKindaWhite")
                }
                return bookCell
                
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if myBooks.count == 0 {

        } else {
            if let bookDetailsViewController = UIStoryboard.library.instantiateViewController(withIdentifier: "BookDetailsViewController") as? BookDetailsViewController {
                bookDetailsViewController.book = myBooks[indexPath.row]
                switch screenType {
                case .taken:
                    bookDetailsViewController.screenType = .fromTaken
                    FirebaseDbManager.fetchUserBy(userID: self.myBooks[indexPath.row].providedByUserID, completion: {user in
                        if let providedUser = user {
                            bookDetailsViewController.bookInUser = providedUser
                            self.navigationController?.pushViewController(bookDetailsViewController, animated: true)
                        }
                    })
                case .provided:
                    bookDetailsViewController.screenType = .fromProvided
                    if self.myBooks[indexPath.row].takenOfUserID == ""{
                        bookDetailsViewController.bookInUser = UserData.user
                        self.navigationController?.pushViewController(bookDetailsViewController, animated: true)
                    } else {
                        FirebaseDbManager.fetchUserBy(userID: self.myBooks[indexPath.row].takenOfUserID, completion: {user in
                            if let takenUser = user {
                                bookDetailsViewController.bookInUser = takenUser
                                self.navigationController?.pushViewController(bookDetailsViewController, animated: true)
                            }
                        })
                    }
                }
            }
        }
    }
}
