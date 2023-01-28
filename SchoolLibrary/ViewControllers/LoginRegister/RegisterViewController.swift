//
//  RegisterViewController.swift
//  SchoolLibrary
//
//  Created by Radi on 3.12.22.
//

import UIKit
import Firebase
import JGProgressHUD

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "crete_new_account_title_register_screen".localized
        setupScreen()
    }
    
    func setupScreen() {
        self.view.addDismissKeyboardGestureRecognizer()
        self.emailTextField.setLeftPaddingPoints(16.0)
        self.passwordTextField.setLeftPaddingPoints(16.0)
        self.confirmPasswordTextField.setLeftPaddingPoints(16.0)
        self.phoneNumberTextField.setLeftPaddingPoints(16.0)
        self.firstNameTextField.setLeftPaddingPoints(16.0)
        self.lastNameTextField.setLeftPaddingPoints(16.0)
    }
    
    @IBAction func createAccountButtonTapped(_ sender: UIButton) {
        guard let email = self.emailTextField.text,
              let lastName = self.lastNameTextField.text,
              let firstName = self.firstNameTextField.text,
              let phoneNumber = self.phoneNumberTextField.text,
              let password = self.passwordTextField.text,
              let confirmPassword = self.confirmPasswordTextField.text else {
            self.showError(error: "incorrect_input_global".localized, delay: 3.0, onDismiss: nil)
            return
        }
        
        if email.isEmpty {
            self.showError(error: "enter_your_email_login".localized, delay: 3.0, onDismiss: nil)
            return
        }
        
        if firstName.isEmpty {
            self.showError(error: "enter_your_first_name".localized, delay: 3.0, onDismiss: nil)
            return
        }
        
        if lastName.isEmpty {
            self.showError(error: "enter_your_last_name".localized, delay: 3.0, onDismiss: nil)
            return
        }
        
        if phoneNumber.isEmpty {
            self.showError(error: "enter_your_phone_number".localized, delay: 3.0, onDismiss: nil)
            return
        }
        
        if password.isEmpty {
            self.showError(error: "enter_your_password".localized, delay: 3.0, onDismiss: nil)
            return
        }
        
        if confirmPassword.isEmpty {
            self.showError(error: "confirm_your_password".localized, delay: 3.0, onDismiss: nil)
            return
        }
        
        if password.count < 8 {
            self.showError(error: "password_needs_to_be_longer_than_seven_symbols".localized , delay: 3.0, onDismiss: nil)
            return
        }
        
        if confirmPassword != password {
            self.showError(error: "your_confirm_password_doesn't_match_the_password".localized , delay: 3.0, onDismiss: nil)
            return
        }
        
        if phoneNumber.count < 10 {
            self.showError(error: "phone_number_must_have_ten_numbers".localized , delay: 3.0, onDismiss: nil)
            return
        }
        
        if phoneNumber.count > 10 {
            self.showError(error: "phone_number_must_have_ten_numbers".localized , delay: 3.0, onDismiss: nil)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { authResult , error in
            if let authResult = authResult {
                let user = User(
                    uid: authResult.user.uid,
                    email: email,
                    password: password,
                    firstName: firstName,
                    lastName: lastName,
                    phoneNumber: phoneNumber)
                UserData.user = user
                
                
                FirebaseDbManager.create(user: user, completion: {
                    if let mainTabBarViewController = UIStoryboard.main.instantiateViewController(withIdentifier: "MainTabBarViewController") as? MainTabBarViewController,
                       let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                        sceneDelegate.setRootViewController(mainTabBarViewController)
                    }
                })
            } else {
                self.showError(error: error?.localizedDescription)
            }
        })
    }
}
