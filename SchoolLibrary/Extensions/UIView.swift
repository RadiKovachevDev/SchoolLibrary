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

    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable
    var gradientTopColor: UIColor {
        get {
            return UIColor.clear
        }
        set {
            let gradient: CAGradientLayer = CAGradientLayer()
            let layerColor = layer.backgroundColor ?? UIColor.clear.cgColor
            gradient.colors = [newValue.cgColor, layerColor]
            gradient.frame = bounds
            gradient.cornerRadius = layer.cornerRadius

            layer.addSublayer(gradient)
        }
    }

    @IBInspectable
    var gradientTopToBottom: UIColor {
        get {
            return UIColor.clear
        }
        set {
            let gradient: CAGradientLayer = CAGradientLayer()
            let layerColor = layer.backgroundColor ?? UIColor.clear.cgColor
            gradient.colors = [newValue.cgColor, layerColor]
            gradient.startPoint = CGPoint(x: 0.5, y: 0.3)
            gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
            gradient.locations = [0, 1]
            gradient.frame = bounds
            gradient.cornerRadius = layer.cornerRadius

            layer.insertSublayer(gradient, at: 0)
        }
    }

    @IBInspectable
    var gradientLeftToRight: UIColor {
        get {
            return UIColor.clear
        }
        set {
            let gradient: CAGradientLayer = CAGradientLayer()
            let layerColor = layer.backgroundColor ?? UIColor.clear.cgColor
            gradient.colors = [newValue.cgColor, layerColor]
            gradient.startPoint = CGPoint(x: 0, y: 0.8)
            gradient.endPoint = CGPoint(x: 0.7, y: 0)
            gradient.locations = [0.2, 1.1, 1.9]
            gradient.frame = bounds
            gradient.cornerRadius = layer.cornerRadius

            layer.insertSublayer(gradient, at: 0)
        }
    }

    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }

    @IBInspectable
    var borderRadius: CGFloat {
        get {
                return layer.cornerRadius

        }
        set {
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }

    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

    func addDismissKeyboardGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer()
        gestureRecognizer.addTarget(self, action: #selector(hideKeyboard))
        self.addGestureRecognizer(gestureRecognizer)
    }

    @objc func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
