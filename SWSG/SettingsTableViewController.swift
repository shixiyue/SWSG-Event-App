//
//  SettingsTableViewController.swift
//  SWSG
//
//  Created by Shi Xiyue on 18/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class SettingsTableViewController: BaseViewController {
    
    private let wrongPassword = "Current password is wrong."
    private let passwordInvalid = "Password must be greater than 6 characters."
    
    @IBOutlet private var settingsTable: UITableView!
    
    override var menuYOffset: CGFloat { return -20 }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTable.tableFooterView = UIView(frame: CGRect.zero)
        addSlideMenuButton()
    }
    
    fileprivate func showChangePassword() {
        let alertController = UIAlertController(title: "Change Password", message: nil, preferredStyle: .alert)
        
        let updateAction = UIAlertAction(title: "OK", style: .default) { [weak alertController] _ in
            guard let alertController = alertController else {
                return
            }
            let currentPasswordTextField = alertController.textFields![0] as UITextField
            let newPasswordTextField = alertController.textFields![1] as UITextField
            
            guard let currentPassword = currentPasswordTextField.text, let newPassword = newPasswordTextField.text else {
                return
            }
            self.changePassword(from: currentPassword, to: newPassword)
        }
        updateAction.isEnabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addTextField { textField in
            textField.placeholder = "Current Password"
            textField.isSecureTextEntry = true
        }
        alertController.addTextField { textField in
            textField.placeholder = "New Password"
            textField.isSecureTextEntry = true
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name.UITextFieldTextDidChange, object: alertController.textFields?[0], queue: OperationQueue.main) { notification in
            let currentPasswordTextField = alertController.textFields![0] as UITextField
            let newPasswordTextField = alertController.textFields![1] as UITextField
            guard let currentPassword = currentPasswordTextField.text, let newPassword = newPasswordTextField.text else {
                return
            }
            
            updateAction.isEnabled = !currentPassword.isEmpty && !newPassword.isEmpty
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name.UITextFieldTextDidChange, object: alertController.textFields?[1], queue: OperationQueue.main) { notification in
            let currentPasswordTextField = alertController.textFields![0] as UITextField
            let newPasswordTextField = alertController.textFields![1] as UITextField
            guard let currentPassword = currentPasswordTextField.text, let newPassword = newPasswordTextField.text else {
                return
            }
            
            updateAction.isEnabled = !currentPassword.isEmpty && !newPassword.isEmpty
        }
        
        alertController.addAction(updateAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func changePassword(from currentPassword: String, to newPassword: String) {
        guard let user = System.activeUser else {
            Utility.logOutUser(currentViewController: self)
            return
        }
        System.client.reauthenticateUser(email: user.email, password: currentPassword, completion: { (error) in
            if let firebaseError = error {
                self.present(Utility.getFailAlertController(message: firebaseError.errorMessage), animated: true, completion: nil)
                return
            }
            System.client.changePassword(newPassword: newPassword, completion: { (error) in
                if let firebaseError = error {
                    self.present(Utility.getFailAlertController(message: firebaseError.errorMessage), animated: true, completion: nil)
                    return
                }
                self.present(Utility.getSuccessAlertController(), animated: true, completion: nil)
            })
        })
    }

}

extension SettingsTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    private enum SettingsItems: Int {
        case changePassword = 0
        case logOut = 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = SettingsItems(rawValue: indexPath.row) else {
            return UITableViewCell()
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "\(row)", for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let row = SettingsItems(rawValue: indexPath.row) else {
            return
        }
        
        switch(row) {
        case .changePassword:
            showChangePassword()
        case .logOut:
            Utility.logOutUser(currentViewController: self)
        }
    }

}
