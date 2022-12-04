//
//  BookDetailsViewController.swift
//  SchoolLibrary
//
//  Created by Radi on 3.12.22.
//

import UIKit

class BookDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension BookDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let imageCell = tableView.dequeueReusableCell(withIdentifier: "BookDetailsImageTableViewCell", for: indexPath) as? BookDetailsImageTableViewCell {
                return imageCell
            }
        case 5:
            if let providedByCell = tableView.dequeueReusableCell(withIdentifier: "BookDetailsProvidedByTableViewCell", for: indexPath) as? BookDetailsProvidedByTableViewCell {
                return providedByCell
            }
        default:
            if let descriptionCell = tableView.dequeueReusableCell(withIdentifier: "BookDetailsDescriptionTableViewCell", for: indexPath) as? BookDetailsDescriptionTableViewCell {
                switch indexPath.row {
                case 1:
                    descriptionCell.descriptionLabel.text = "Book name"
                case 2:
                    descriptionCell.descriptionLabel.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
                case 3:
                    descriptionCell.descriptionLabel.text = "Author"
                case 4:
                    descriptionCell.descriptionLabel.text = "Publisher"
                default:
                    break
                }
                
                return descriptionCell
            }
         }
        return UITableViewCell()
    }
    
    
}
