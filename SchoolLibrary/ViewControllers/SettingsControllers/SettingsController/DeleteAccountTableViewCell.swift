//
//  DeleteAccountTableViewCell.swift
//  SchoolLibrary
//
//  Created by Radi on 11.12.22.
//

import UIKit

class DeleteAccountTableViewCell: UITableViewCell {

    @IBOutlet weak var deleteAccountButton: UIButton!
    var errorEvent: StringEvent?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func deleteAccountButtonTapped(_ sender: UIButton) {
        guard let user = UserData.user else { return }
        
        if FirebaseDbManager.books.filter({$0.takenOfUserID == user.uid}).count > 0 {
            errorEvent?("taken_book_delete_account_button_massage".localized)
        }else if FirebaseDbManager.books.filter({$0.providedByUserID == user.uid && $0.takenOfUserID != ""}).count > 0 {
            errorEvent?("provided_book_delete_account_button_massage".localized)
        } else {
            errorEvent?("")
        }
            
    }
}
