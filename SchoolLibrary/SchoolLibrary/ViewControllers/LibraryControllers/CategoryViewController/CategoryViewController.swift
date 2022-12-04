//
//  CategoryViewController.swift
//  SchoolLibrary
//
//  Created by Radi on 3.12.22.
//

import UIKit

class CategoryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var categoryName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = categoryName
    }
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let bookCell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell", for: indexPath) as? BookTableViewCell {
            return bookCell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let bookDetailsViewController = UIStoryboard.library.instantiateViewController(withIdentifier: "BookDetailsViewController") as? BookDetailsViewController {
            self.navigationController?.pushViewController(bookDetailsViewController, animated: true)
        }
    }
}
