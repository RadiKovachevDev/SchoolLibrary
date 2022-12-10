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
    
    var phoneNumber: String?
    var mail: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func sendMailButtonTapped(_ sender: UIButton) {
        if let mail = self.mail,
           let url = URL(string:  "mailto:\(mail)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func callButtonTapped(_ sender: UIButton) {
        if let phoneNumber = self.phoneNumber,
           let url = URL(string: "tel://\(phoneNumber)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}
