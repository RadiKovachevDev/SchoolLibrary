//
//  SettingsViewController.swift
//  SchoolLibrary
//
//  Created by Radi on 1.12.22.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var sections = ["User info", "App settings", "About", "Delete account"]
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.user = FakeDB.users.first(where: {$0.uid == "idrnk"})
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        self.sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
        let label = UILabel()
        label.frame = CGRect.init(x: 0, y: 0, width: headerView.frame.width, height: headerView.frame.height)
        label.text = self.sections[section]
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = UIColor(named: "slDustyBlack")
        label.backgroundColor = .clear
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 2
        case 2:
            return 4
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            if let settingsInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SettingsInfoTableViewCell", for: indexPath) as? SettingsInfoTableViewCell,
               let currentUser = self.user {
                switch indexPath.row {
                case 0:
                    settingsInfoTableViewCell.titleLabel.text = "Name"
                    settingsInfoTableViewCell.valueLabel.text = "\(currentUser.firstName) \(currentUser.lastName)"
                case 1:
                    settingsInfoTableViewCell.titleLabel.text = "Email"
                    settingsInfoTableViewCell.valueLabel.text = "\(currentUser.email)"
                case 2:
                    settingsInfoTableViewCell.titleLabel.text = "Phone number"
                    settingsInfoTableViewCell.valueLabel.text = "\(currentUser.phoneNumber)"
                default:
                    settingsInfoTableViewCell.valueLabel.text = ""
                }
                return settingsInfoTableViewCell
            }
        case 1:
            if let settingAppTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SettingAppTableViewCell", for: indexPath) as? SettingAppTableViewCell {
                settingAppTableViewCell.titleLabel.isHidden = false
                settingAppTableViewCell.valueLabel.isHidden = false
                switch indexPath.row {
                case 0:
                    settingAppTableViewCell.titleLabel.text = "Default languege"
                    settingAppTableViewCell.valueLabel.text = "BG"
                default:
                    settingAppTableViewCell.titleLabel.text = "Logout"
                    settingAppTableViewCell.valueLabel.isHidden = true
                }
                return settingAppTableViewCell
            }
        case 2:
            if let settingAppTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SettingAppTableViewCell", for: indexPath) as? SettingAppTableViewCell {
                settingAppTableViewCell.titleLabel.isHidden = false
                settingAppTableViewCell.valueLabel.isHidden = false
                switch indexPath.row {
                case 0:
                    settingAppTableViewCell.titleLabel.text = "Version"
                    settingAppTableViewCell.valueLabel.text = "1.0.0(1)"
                case 1:
                    settingAppTableViewCell.titleLabel.text = "Terms of service"
                    settingAppTableViewCell.valueLabel.isHidden = true
                case 2:
                    settingAppTableViewCell.titleLabel.text = "Privacy policy"
                    settingAppTableViewCell.valueLabel.isHidden = true
                case 3:
                    settingAppTableViewCell.titleLabel.text = "Contact us"
                    settingAppTableViewCell.valueLabel.isHidden = true
                default:
                    settingAppTableViewCell.titleLabel.text = ""
                    settingAppTableViewCell.valueLabel.isHidden = true
                }
                return settingAppTableViewCell
            }
        default:
            if let deleteAccountTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DeleteAccountTableViewCell", for: indexPath) as? DeleteAccountTableViewCell {
                return deleteAccountTableViewCell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            switch indexPath.row {
            case 1:
                logOut()
            default:
                break
            }
        default:
            break
        }
    }
    
    func logOut() {
        UserData.user = nil
        if let loginViewController = UIStoryboard.main.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController,
           let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.setRootViewController(loginViewController)
        }
    }
}
