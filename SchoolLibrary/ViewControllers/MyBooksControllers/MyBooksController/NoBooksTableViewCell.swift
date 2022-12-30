//
//  NoBooksTableViewCell.swift
//  SchoolLibrary
//
//  Created by Radi on 30.12.22.
//

import UIKit

class NoBooksTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
