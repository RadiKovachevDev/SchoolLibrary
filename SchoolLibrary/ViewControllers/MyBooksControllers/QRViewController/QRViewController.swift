//
//  QRViewController.swift
//  SchoolLibrary
//
//  Created by Radi on 17.12.22.
//

import UIKit

class QRViewController: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var qrImageview: UIImageView!
    var generatedQRUIImage: UIImage?
    var operationDescription = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        qrImageview.image = generatedQRUIImage
        descriptionLabel.text = operationDescription
    }
}
