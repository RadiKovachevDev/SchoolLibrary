//
//  BookDetailsProvidedByTableViewCell.swift
//  SchoolLibrary
//
//  Created by Radi on 3.12.22.
//

import UIKit
import JGProgressHUD

class BookDetailsProvidedByTableViewCell: UITableViewCell {
    
    @IBOutlet weak var providedByLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var secondaryButton: UIButton!
    @IBOutlet weak var primaryButton: UIButton!
    @IBOutlet weak var generateQRCode: UIButton!
    
    var generateQRClicked: Event?
    
    var phoneNumber: String?
    var mail: String?
    var screenType: BookScreenType = .standartScreen
    
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
    
    @IBAction func CallButtonTapped(_ sender: UIButton) {
        if let phoneNumber = self.phoneNumber,
           let url = URL(string: "tel://\(phoneNumber)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func generateQRCodeButtonTapped(_ sender: UIButton) {
        generateQRClicked?()
    }
}
