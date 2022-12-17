//
//  QRGenerator.swift
//  SchoolLibrary
//
//  Created by Radi on 17.12.22.
//

import Foundation
import UIKit

final class QRGenerator {
    
    static func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        if let QRFilter = CIFilter(name: "CIQRCodeGenerator") {
            QRFilter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 12, y: 12)
            guard let QRImage = QRFilter.outputImage?.transformed(by: transform) else {return nil}
            return UIImage(ciImage: QRImage.tinted(using: UIColor(named: "slDustyBlack") ?? .black) ?? .blue)
        }
        return nil
    }
}
