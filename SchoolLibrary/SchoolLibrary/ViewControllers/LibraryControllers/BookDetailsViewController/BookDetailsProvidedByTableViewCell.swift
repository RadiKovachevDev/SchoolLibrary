//
//  BookDetailsProvidedByTableViewCell.swift
//  SchoolLibrary
//
//  Created by Radi on 3.12.22.
//

import UIKit

class BookDetailsProvidedByTableViewCell: UITableViewCell {

    @IBOutlet weak var providedByLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var sendMailButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func sendMailButtonTapped(_ sender: UIButton) {
        if let url = URL(string: "mailto:radi.kovachev.dev@gmail.com") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
    }
    
    @IBAction func callButtonTapped(_ sender: UIButton) {
        if let url = URL(string: "tel://+359896005797") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
    }
    
}
