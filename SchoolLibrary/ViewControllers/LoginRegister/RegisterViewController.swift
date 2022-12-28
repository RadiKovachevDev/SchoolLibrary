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
    
    var db: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
    }
    
    func setupScreen() {
        self.db = Database.database().reference()
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
            self.showError(error: "Incorect input data", delay: 3.0, onDismiss: nil)
            return
        }
        
        if email.isEmpty {
            self.showError(error: "Enter your email", delay: 3.0, onDismiss: nil)
            return
        }
        
        if firstName.isEmpty {
            self.showError(error: "Enter your first name", delay: 3.0, onDismiss: nil)
            return
        }
        
        if lastName.isEmpty {
            self.showError(error: "Enter your last name", delay: 3.0, onDismiss: nil)
            return
        }
        
        if phoneNumber.isEmpty {
            self.showError(error: "Enter your phone number", delay: 3.0, onDismiss: nil)
            return
        }
        
        if password.isEmpty {
            self.showError(error: "Enter your password", delay: 3.0, onDismiss: nil)
            return
        }
        
        if confirmPassword.isEmpty {
            self.showError(error: "Confirm your password", delay: 3.0, onDismiss: nil)
            return
        }
        
        if password.count < 8 {
            self.showError(error: "Password needs to longer than seven symbols" , delay: 3.0, onDismiss: nil)
            return
        }
        
        if confirmPassword != password {
            self.showError(error: "Your confirm password doesn't match the password" , delay: 3.0, onDismiss: nil)
            return
        }
        
        if phoneNumber.count < 10 {
            self.showError(error: "Number must too have ten numbers" , delay: 3.0, onDismiss: nil)
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
                
                self.db.child("Users").child("\(UserData.user?.uid ?? "errorUID")").setValue([
                    "userDetails" : [
                        "uid": authResult.user.uid,
                        "firstName" : firstName,
                        "lastName" : lastName,
                        "email" : email,
                        "phoneNumber" : phoneNumber
                    ]
                ])
                if let mainTabBarViewController = UIStoryboard.main.instantiateViewController(withIdentifier: "MainTabBarViewController") as? MainTabBarViewController,
                   let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    sceneDelegate.setRootViewController(mainTabBarViewController)
                }
            } else {
                self.showError(error: error?.localizedDescription)
            }
        })
    }
}
