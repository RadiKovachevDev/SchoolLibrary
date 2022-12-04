//
//  UIView.swift
//  SchoolLibrary
//
//  Created by Radi on 3.12.22.
//

import UIKit

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}
