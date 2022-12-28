//
//  CreateBookViewController.swift
//  SchoolLibrary
//
//  Created by Radi on 17.12.22.
//

import UIKit
import JGProgressHUD
import Firebase

class CreateBookViewController: UIViewController {
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var bookNameTextField: UITextField!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    @IBOutlet weak var bookAuthorTextField: UITextField!
    @IBOutlet weak var shortDiscriptionLabel: UILabel!
    @IBOutlet weak var shortDiscriptionTextView: UITextView!
    @IBOutlet weak var longDiscriptionLabel: UILabel!
    @IBOutlet weak var longDiscriptionTextView: UITextView!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var publisherTextField: UITextField!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var createBookButton: UIButton!
    
    var db: DatabaseReference!
    
    var categoryPicker = UIPickerView()
    var categories: [Category] = []
    var selectedCategory: Category?
    var toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 250, width: UIScreen.main.bounds.size.width, height: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.db = Database.database().reference()
        self.categories = Category.allCategories()
        self.categories.removeFirst()
        self.view.addDismissKeyboardGestureRecognizer()
        self.bookNameTextField.setLeftPaddingPoints(16.0)
        self.bookAuthorTextField.setLeftPaddingPoints(16.0)
        self.shortDiscriptionTextView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        self.longDiscriptionTextView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        self.publisherTextField.setLeftPaddingPoints(16.0)
        self.categoryTextField.setLeftPaddingPoints(16.0)
    }
    
    @IBAction func showPicker(_ sender: UITextField) {
        setupCategoryPicker()
    }
    
    @IBAction func createBookButtonTapped(_ sender: UIButton) {
        guard let bookName = self.bookNameTextField.text,
              let bookAuthor = self.bookAuthorTextField.text,
              let shortDiscription = self.shortDiscriptionTextView.text,
              let longDiscription = self.longDiscriptionTextView.text,
              let publisher = self.publisherTextField.text,
              let category = self.categoryTextField.text else {
            self.showError(error: "Missing data", delay: 3.0, onDismiss: nil)
            return
        }

        if bookName.isEmpty {
            self.showError(error: "Enter the name of the book", delay: 3.0, onDismiss: nil)
            return
        }

        if bookName.count < 3 && bookName.count > 100 {
            self.showError(error: "The book name needs to be between 3 and 100", delay: 3.0, onDismiss: nil)
            return
        }

        if bookAuthor.isEmpty {
            self.showError(error: "Enter the author of the book", delay: 3.0, onDismiss: nil)
            return
        }

        if bookAuthor.count < 3 && bookAuthor.count > 100 {
            self.showError(error: "The authors name needs to be between 3 and 100", delay: 3.0, onDismiss: nil)
            return
        }

        if shortDiscription.isEmpty {
            self.showError(error: "Enter your short discription of the book", delay: 3.0, onDismiss: nil)
            return
        }

        if shortDiscription.count < 100 && shortDiscription.count > 200 {
            self.showError(error: "Short discription needs to be between 100 and 200", delay: 3.0, onDismiss: nil)
            return
        }

        if longDiscription.count < 100 && longDiscription.count > 600{
            self.showError(error: "Long discription needs to be between 100 and 600", delay: 3.0, onDismiss: nil)
            return
        }

        if publisher.isEmpty {
            self.showError(error: "Enter the publisher of the book", delay: 3.0, onDismiss: nil)
            return
        }

        if publisher.count < 3 && publisher.count > 100 {
            self.showError(error: "The publisher name needs to be between 3 and 100", delay: 3.0, onDismiss: nil)
            return
        }

        if category.isEmpty {
            self.showError(error: "Enter the category of the book", delay: 3.0, onDismiss: nil)
            return
        }

        guard let user = UserData.user else {
            return
        }

        let id = "\(user.uid)\(Int(Date().timeIntervalSince1970))"

        self.db.child("Books").child("\(id)").setValue([
            "bookDetails" : [
                "id": id,
                "bookName" : bookName,
                "bookAuthor" : bookAuthor,
                "shortDiscription" : shortDiscription,
                "longDiscription" : longDiscription,
                "publisher": publisher,
                "image" : "defoult_category_image",
                "category": category,
                "providedByUserID": user.uid,
                "takenOfUserID": "",
                "isAvalible": true,
                "bookReturnData": ""
            ]
        ])
        self.navigationController?.popViewController(animated: true)
    }

    func setupCategoryPicker() {
        categoryPicker.delegate = self
        categoryPicker.backgroundColor = UIColor(named: "slKindaWhite")
        categoryPicker.setValue(UIColor(named: "slKindaBlack"), forKey: "textColor")
        categoryPicker.autoresizingMask = .flexibleWidth
        categoryPicker.contentMode = .center
        categoryPicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 250, width: UIScreen.main.bounds.size.width, height: 250)
        self.view.addSubview(categoryPicker)
        
        toolBar.barStyle = .default
        toolBar.barTintColor = UIColor(named: "slKindaWhite")
        toolBar.tintColor = UIColor(named: "slKindaBlack")
        let done = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexibleSpace, done], animated: false)
        categoryPicker.hideKeyboard()
        self.tabBarController?.tabBar.isHidden = true
        self.view.addSubview(toolBar)
    }
}

extension CreateBookViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.categories[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.categoryTextField.text = self.categories[row].rawValue
        self.selectedCategory = self.categories[row]
        hidePicker()
    }
    
    func hidePicker() {
        toolBar.removeFromSuperview()
        categoryPicker.removeFromSuperview()
        view.endEditing(true)
    }
    
    @objc func onDoneButtonTapped() {
        hidePicker()
    }
    
}
