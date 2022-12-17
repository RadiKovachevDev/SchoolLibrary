//
//  UIViewController.swift
//  SchoolLibrary
//
//  Created by Radi on 17.12.22.
//

import Foundation
import UIKit
import JGProgressHUD

extension UIViewController {
    func showProgressHUD() {
        JGProgressHUD().show(in: self.view)
    }

    func dismissProgressHUD() {
        for progressHuds in self.view.subviews where progressHuds is JGProgressHUD {
            (progressHuds as? JGProgressHUD)?.dismiss()
        }
    }

    func showError(error: String?) {
        self.dismissProgressHUD()
        let hud = JGProgressHUD()
        hud.textLabel.text = error
        hud.indicatorView = JGProgressHUDErrorIndicatorView()
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 3.0)
    }

    func showError(error: String?, delay: Double = 3.0, onDismiss: (() -> Void)? = nil) {
        self.dismissProgressHUD()
        let hud = JGProgressHUD()
        hud.textLabel.text = error
        hud.indicatorView = JGProgressHUDErrorIndicatorView()
        hud.show(in: self.view)

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            hud.dismiss()
            onDismiss?()
        }
    }

    func showMessage(message: String?, delay: Double = 3.0, onDismiss: (() -> Void)? = nil) {
        self.dismissProgressHUD()
        let hud = JGProgressHUD()
        hud.textLabel.text = message
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.show(in: self.view)

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            hud.dismiss()
            onDismiss?()
        }
    }
}
