//
//  InitialViewController.swift
//  SchoolLibrary
//
//  Created by Radi on 1.12.22.
//

import UIKit

class InitialViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
        if UserData.userID == nil {
            self.performSegue(withIdentifier: "toLoginSegue", sender: nil)
        } else {
            self.performSegue(withIdentifier: "toAppSegue", sender: nil)
        }
    }
}
