//
//  RegisterViewController.swift
//  SchoolLibrary
//
//  Created by Radi on 3.12.22.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
    }
    
    func setupScreen() {
        self.view.addDismissKeyboardGestureRecognizer()
        self.emailTextField.setLeftPaddingPoints(16.0)
        self.passwordTextField.setLeftPaddingPoints(16.0)
        self.confirmPasswordTextField.setLeftPaddingPoints(16.0)
        self.phoneNumberTextField.setLeftPaddingPoints(16.0)
    }
    
    @IBAction func createAccountButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "registerToAppSegue", sender: nil)
    }
}
