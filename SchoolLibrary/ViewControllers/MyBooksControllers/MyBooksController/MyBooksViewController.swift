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
        self.actionButton.setTitle("Scan book QR", for: .normal)
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
            switch screenType {
            case .taken:
                bookDetailsViewController.screenType = .fromTaken
            case .provided:
                bookDetailsViewController.screenType = .fromProvided
            }
            bookDetailsViewController.book = myBooks[indexPath.row]
            self.navigationController?.pushViewController(bookDetailsViewController, animated: true)
        }
    }
    
    
}
