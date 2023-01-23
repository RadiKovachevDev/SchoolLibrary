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
    @IBOutlet weak var actionButton: UIButton!
    
    var screenType: MyBooksScreenType = .taken
    var myBooks: [Book] = []
    var myRightBarButtonItem = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myRightBarButtonItem = self.navigationItem.rightBarButtonItem ?? UIBarButtonItem()
        setupScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FirebaseDbManager.fetchBooks {
            self.setupScreen()
        }
    }
    
    func setupScreen() {
        guard let user = UserData.user else { return }
        self.actionButton.setTitle("Scan book QR", for: .normal)
        switch screenType {
        case .taken:
            myBooks = FirebaseDbManager.books.filter({$0.takenOfUserID == user.uid})
            self.navigationItem.rightBarButtonItem = nil
        case .provided:
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
                    actions.append(("Ok", .cancel))
                    Alerts.showAlert(viewController: self, title: "Camera permission", message: "The application does not have permission to use the camera. If you want to change the state of the permission, go to iPhone Setting → SchoolLibrary app → Camera toggle", actions: actions, completion: {index in
                        switch index {
                        default:
                            break
                        }
                    })
                }
            }
        case .restricted, .denied:
            var actions: [(String, UIAlertAction.Style)] = []
            actions.append(("Ok", .cancel))
            Alerts.showAlert(viewController: self, title: "Camera permission", message: "The application does not have permission to use the camera. If you want to change the state of the permission, go to iPhone Setting → ChangeX app → Camera toggle", actions: actions, completion: {index in
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
            showError(error: "error", delay: 3.0, onDismiss: nil)
        } else {
            guard let book = FirebaseDbManager.books.first(where: {$0.id == result}),
                  let user = UserData.user else {
                showError(error: "no book", delay: 3.0, onDismiss: nil)
                return
            }
            
            if screenType == .taken && book.providedByUserID == user.uid {
                showError(error: "Unauthorized operation", delay: 3.0, onDismiss: nil)
                return
            }
            
            var modifyBook = book
            
            var actions: [(String, UIAlertAction.Style)] = []
            
            switch screenType {
            case .taken:
                let timestamp = Date().timeIntervalSince1970
                let timestampReturn = Int(timestamp) + 2592000
                actions.append(("Yes, i recived the book", .default))
                actions.append(("Cancel", .cancel))
                Alerts.showActionsheet(viewController: self, title: "Taken book", message: "I took \(book.name) and i need to return it on \(timestampReturn.timestampToDate())", actions: actions, completion: {index in
                    switch index {
                    case 0:
                        modifyBook.takenOfUserID = user.uid
                        modifyBook.bookReturnData = "\(timestampReturn)"
                        FirebaseDbManager.create(book: modifyBook, completion: {
                            FirebaseDbManager.fetchBooks {
                                self.showMessage(message: "Done",delay: 3.0, onDismiss: {
                                    self.setupScreen()
                                })
                            }
                        })
                    default:
                        break
                    }
                })
            case .provided:
                actions.append(("My book was returned", .default))
                actions.append(("Cancel", .cancel))
                Alerts.showActionsheet(viewController: self, title: "Done", message: "I have received my book back", actions: actions, completion: {index in
                    switch index {
                    case 0:
                        modifyBook.takenOfUserID = ""
                        modifyBook.bookReturnData = ""
                        FirebaseDbManager.create(book: modifyBook, completion: {
                            FirebaseDbManager.fetchBooks {
                                self.showMessage(message: "Done", delay: 3.0, onDismiss: {
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
                    noBooksCell.titleLabel.text = "No taken book"
                    noBooksCell.descriptionLabel.text = "Може да разгледате свободните книги и да се свържете със собственика за да ви бъде предоставена"
                case .provided:
                    noBooksCell.titleLabel.text = "No provided book"
                    noBooksCell.descriptionLabel.text = "Може да разгледате свободните книги и да се свържете със собственика за да ви бъде предоставена"
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
