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
        guard let email = self.emailTextField.text,
              let password = self.passwordTextField.text else {
            self.showError(error: "Incorect email or password", delay: 3.0, onDismiss: nil)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { authResult , error in
            if error == nil {
                UserData.userID = authResult?.user.uid
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
