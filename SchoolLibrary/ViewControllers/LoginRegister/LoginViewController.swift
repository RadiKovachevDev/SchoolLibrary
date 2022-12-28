//
//  LoginViewController.swift
//  SchoolLibrary
//
//  Created by Radi on 3.12.22.
//

import UIKit
import Firebase
import JGProgressHUD

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
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
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
//        self.performSegue(withIdentifier: "toRegisterSegue", sender: nil)
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let email = self.emailTextField.text,
              let password = self.passwordTextField.text else {
            self.showError(error: "Incorect email or password", delay: 3.0, onDismiss: nil)
            return
        }
        
        if email.isEmpty {
            self.showError(error: "Enter your email", delay: 3.0, onDismiss: nil)
            return
        }
        
        if password.isEmpty {
            self.showError(error: "Enter your password", delay: 3.0, onDismiss: nil)
            return
        }
        
        
        self.showProgressHUD()
        Auth.auth().signIn(withEmail: email, password: password, completion: {authResult,error in
            self.dismissProgressHUD()
            if let authResult = authResult {
                var user = User(
                    uid: authResult.user.uid,
                    email: email,
                    password: password,
                    firstName: "",
                    lastName: "",
                    phoneNumber: "")
                self.showProgressHUD()
                self.db.child("Users").child("\(user.uid ?? "errorUID")").observe(.childAdded, with: { snapshot in
                    self.dismissProgressHUD()
                    if let dict = snapshot.value as? [String:Any],
                       let firstName = dict["firstName"] as? String,
                       let lastName = dict["lastName"] as? String,
                       let phoneNumber = dict["phoneNumber"] as? String {
                        user.firstName = firstName
                        user.lastName = lastName
                        user.phoneNumber = phoneNumber
                    }
                    
                    UserData.user = user
                    if let mainTabBarViewController = UIStoryboard.main.instantiateViewController(withIdentifier: "MainTabBarViewController") as? MainTabBarViewController,
                       let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                        sceneDelegate.setRootViewController(mainTabBarViewController)
                    }
                })
                
            } else {
                if let error = error {
                    self.showError(error: error.localizedDescription, delay: 3.0, onDismiss: nil)
                }
            }
        })
    }
}
