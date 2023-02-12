//
//  SettingsViewController.swift
//  SchoolLibrary
//
//  Created by Radi on 1.12.22.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var sections = ["user_info_section".localized, "app_settings_section".localized, "about_section".localized, "delete_account_section".localized]
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTabBarTitles()
        self.title = "settings_screen_title".localized
        self.user = UserData.user
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
                    settingsInfoTableViewCell.titleLabel.text = "name_title".localized
                    settingsInfoTableViewCell.valueLabel.text = "\(currentUser.firstName) \(currentUser.lastName)"
                case 1:
                    settingsInfoTableViewCell.titleLabel.text = "email_title".localized
                    settingsInfoTableViewCell.valueLabel.text = "\(currentUser.email)"
                case 2:
                    settingsInfoTableViewCell.titleLabel.text = "phone_number_title".localized
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
                    settingAppTableViewCell.titleLabel.text = "default_language_title".localized
                    settingAppTableViewCell.valueLabel.text = UserData.selectedLanguage?.uppercased()
                default:
                    settingAppTableViewCell.titleLabel.text = "logout_title".localized
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
                    settingAppTableViewCell.titleLabel.text = "version_title".localized
                    settingAppTableViewCell.valueLabel.text = Bundle.main.releaseVersionNumberPretty
                case 1:
                    settingAppTableViewCell.titleLabel.text = "terms_&_condition_title".localized
                    settingAppTableViewCell.valueLabel.isHidden = true
                case 2:
                    settingAppTableViewCell.titleLabel.text = "privacy_policy_title".localized
                    settingAppTableViewCell.valueLabel.isHidden = true
                case 3:
                    settingAppTableViewCell.titleLabel.text = "contact_us_title".localized
                    settingAppTableViewCell.valueLabel.isHidden = true
                default:
                    settingAppTableViewCell.titleLabel.text = ""
                    settingAppTableViewCell.valueLabel.isHidden = true
                }
                return settingAppTableViewCell
            }
        default:
            if let deleteAccountTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DeleteAccountTableViewCell", for: indexPath) as? DeleteAccountTableViewCell {
                deleteAccountTableViewCell.deleteAccountButton.setTitle("delete_account_title".localized, for: .normal)
                return deleteAccountTableViewCell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            switch indexPath.row {
            case 0:
                setupDefaultLanguage()
            case 1:
                logOut()
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 3:
                contactUse()
            default:
                break
            }
        default:
            break
        }
    }
    
    func logOut() {
        UserData.user = nil
        if let initialViewController = UIStoryboard.main.instantiateViewController(withIdentifier: "InitialViewController") as? InitialViewController,
           let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.setRootViewController(initialViewController)
        }
    }
    
    func contactUse() {
        if let url = URL(string:  "mailto:radi.kovachev.dev@gmail.com") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func setupDefaultLanguage() {
            var actions: [(String, UIAlertAction.Style)] = []
            actions.append(("\(DefaultLanguage.BG.rawValue.uppercased())", .default))
            actions.append(("\(DefaultLanguage.EN.rawValue.uppercased())", .default))
        actions.append(("cancel_global_title".localized, .cancel))

        Alerts.showActionsheet(viewController: self, title: "languages_title".localized, message: "select_default_language".localized, actions: actions) { (index) in
            switch index {
            case 0:
                UserData.selectedLanguage = DefaultLanguage.BG.rawValue
            case 1:
                UserData.selectedLanguage = DefaultLanguage.EN.rawValue
            default:
                return
            }
            self.tableView.reloadData()
            self.sections = ["user_info_section".localized, "app_settings_section".localized, "about_section".localized, "delete_account_section".localized]
            self.title = "settings_screen_title".localized
            self.updateTabBarTitles()
        }
    }}
