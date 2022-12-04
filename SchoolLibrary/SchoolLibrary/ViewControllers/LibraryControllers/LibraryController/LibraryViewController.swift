//
//  LibraryViewController.swift
//  SchoolLibrary
//
//  Created by Radi on 1.12.22.
//

import UIKit

class LibraryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var categories = ["Mатематика", "Биология", "Физика", "Английски", "Френски", "Програмиране", "Музика", "Романи", "Фантастика"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension LibraryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let categoryCell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as? CategoryTableViewCell{
            categoryCell.categoryNameLabel.text = categories[indexPath.row]
            categoryCell.booksInCategoryLabel.text = "Books in category: \(indexPath.row + 1)"
            return categoryCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let categoryViewController = UIStoryboard.library.instantiateViewController(withIdentifier: "CategoryViewController") as? CategoryViewController {
            categoryViewController.categoryName = categories[indexPath.row]
            self.navigationController?.pushViewController(categoryViewController, animated: true)
        }
    }
}
