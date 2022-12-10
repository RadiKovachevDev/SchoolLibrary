//
//  ProvidedViewController.swift
//  SchoolLibrary
//
//  Created by Radi on 1.12.22.
//

import UIKit

class MyBooksViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var myBooksSegment: UISegmentedControl!
    @IBOutlet weak var actionButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func changeSegmentState(_ sender: UISegmentedControl) {
        self.tableView.reloadData()
    }
    
    @IBAction func actionButtonTaped(_ sender: UIButton) {
    }
}

extension MyBooksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.myBooksSegment.selectedSegmentIndex {
        case 0:
            return 3
        default:
            return 5
        }
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
