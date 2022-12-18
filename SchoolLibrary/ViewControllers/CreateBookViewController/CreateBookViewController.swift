//
//  CreateBookViewController.swift
//  SchoolLibrary
//
//  Created by Radi on 17.12.22.
//

import UIKit

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
    
    var categoryPicker = UIPickerView()
    var categories: [Category] = []
    var selectedCategory: Category?
    var toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 250, width: UIScreen.main.bounds.size.width, height: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categories = Category.allCategories()
        self.categories.removeFirst()
    }
    
    @IBAction func showPicker(_ sender: UITextField) {
        setupCategoryPicker()
    }
    
    func setupCategoryPicker() {
        categoryPicker.delegate = self
        categoryPicker.backgroundColor = UIColor(named: "xBoxBackground")
        categoryPicker.setValue(UIColor(named: "xDustyWhite"), forKey: "textColor")
        categoryPicker.autoresizingMask = .flexibleWidth
        categoryPicker.contentMode = .center
        categoryPicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 250, width: UIScreen.main.bounds.size.width, height: 250)
        categoryPicker.selectRow(self.selectedCategory.hashValue, inComponent: 0, animated: true)
        self.view.addSubview(categoryPicker)
        
        toolBar.barStyle = .default
        toolBar.barTintColor = UIColor(named: "xBoxBackground")
        toolBar.tintColor = UIColor(named: "xDustyWhite")
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
