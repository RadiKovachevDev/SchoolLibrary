//
//  Alerts.swift
//  SchoolLibrary
//
//  Created by Radi on 17.12.22.
//

import Foundation
import UIKit

class Alerts {
    static func showActionsheet(viewController: UIViewController, title: String, message: String, actions: [(String, UIAlertAction.Style)], completion: @escaping (_ index: Int) -> Void) {

        var alertViewController = UIAlertController()

        if UIDevice.current.userInterfaceIdiom != .phone {
            alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        } else {
            alertViewController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        }

        let titleFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0)]
        let titleAttrString = NSMutableAttributedString(string: title, attributes: titleFont)

        let subView = alertViewController.view.subviews.first!
        let contentView = subView.subviews.first!
        contentView.subviews.first?.backgroundColor = UIColor(named: "slWhite")
        contentView.layer.cornerRadius = 12.0

        alertViewController.setValue(titleAttrString, forKey: "attributedTitle")

        for (index, (title, style)) in actions.enumerated() {
            let alertAction = UIAlertAction(title: title, style: style) { (_) in
                completion(index)
            }
//            alertAction.setValue(UIColor(named: "xDustyWhite"), forKey: "titleTextColor")
            alertViewController.addAction(alertAction)
        }

        if UIDevice.current.userInterfaceIdiom != .phone {
            alertViewController.popoverPresentationController?.sourceView = viewController.view
            alertViewController.popoverPresentationController?.sourceRect = viewController.view.bounds
        }

        alertViewController.view.tintColor = UIColor(named: "slWhite")

        viewController.present(alertViewController, animated: true, completion: nil)
    }

    static func showAlert(viewController: UIViewController, title: String, message: String, actions: [(String, UIAlertAction.Style)], completion: @escaping (_ index: Int) -> Void) {

        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let titleFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0)]
        let titleAttrString = NSMutableAttributedString(string: title, attributes: titleFont)

        let subView = alertViewController.view.subviews.first!
        let contentView = subView.subviews.first!
        contentView.subviews.first?.backgroundColor = UIColor(named: "slWhite")
        contentView.layer.cornerRadius = 12.0

        alertViewController.setValue(titleAttrString, forKey: "attributedTitle")

        for (index, (title, style)) in actions.enumerated() {
            let alertAction = UIAlertAction(title: title, style: style) { (_) in
                completion(index)
            }
//            alertAction.setValue(UIColor(named: "xDustyWhite"), forKey: "titleTextColor")
            alertViewController.addAction(alertAction)
        }
        if UIDevice.current.userInterfaceIdiom != .phone {
            alertViewController.popoverPresentationController?.sourceView = viewController.view
            alertViewController.popoverPresentationController?.sourceRect = viewController.view.bounds
        }

        alertViewController.view.tintColor = UIColor(named: "slBlack")

        viewController.present(alertViewController, animated: true, completion: nil)
    }
}
