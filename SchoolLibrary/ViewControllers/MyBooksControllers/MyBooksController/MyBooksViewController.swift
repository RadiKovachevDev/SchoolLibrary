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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
    }
    
    func setupScreen() {
        FirebaseDbManager.fetchBooks()
        self.actionButton.setTitle("Scan book QR", for: .normal)
        switch screenType {
        case .taken:
            myBooks = FirebaseDbManager.books.filter({$0.takenOfUserID == UserData.user?.uid})
        case .provided:
            myBooks = FirebaseDbManager.books.filter({$0.providedByUserID == UserData.user?.uid})
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
        switch screenType {
        case .taken:
            openQRScanner()
        case .provided:
            openQRScanner()
        }
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
                        DispatchQueue.main.async {
                            if response {
                                if let qRScannerViewController = UIStoryboard.myBooks.instantiateViewController(withIdentifier: "QRScannerViewController") as? QRScannerViewController{
                                    qRScannerViewController.returnQRCode = { [weak self] qrCode in
                                        self?.showMessage(message: qrCode, delay: 3.0, onDismiss: nil)
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
                            self?.showMessage(message: qrCode, delay: 3.0, onDismiss: nil)
                        }
                        self.present(qRScannerViewController, animated: true)
                    }
                @unknown default:
                    print("default")
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
                return bookCell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if myBooks.count == 0 {
            
        } else {
            if let bookDetailsViewController = UIStoryboard.library.instantiateViewController(withIdentifier: "BookDetailsViewController") as? BookDetailsViewController {
                switch screenType {
                case .taken:
                    bookDetailsViewController.screenType = .fromTaken
                case .provided:
                    bookDetailsViewController.screenType = .fromProvided
                }
                bookDetailsViewController.book = myBooks[indexPath.row]
                FirebaseDbManager.fetchUserBy(userID: self.myBooks[indexPath.row].providedByUserID, completion: {user in
                    if let providedUser = user {
                        bookDetailsViewController.providedUser = providedUser
                        self.navigationController?.pushViewController(bookDetailsViewController, animated: true)
                    }
                })
            }
        }
    }
}
