//
//  SettingsTableViewController.swift
//  SWSG
//
//  Created by Shi Xiyue on 18/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet private var settingsTable: UITableView!
    
    private let wrongPassword = "Current password is wrong."
    private let passwordInvalid = "Password must be greater than 6 characters."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTable.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        switch(row) {
        case 0:
            showChangePassword()
        case 1:
            Utility.logOutUser(currentViewController: self)
        default: break
        }
    }
    
    private func showChangePassword() {
        let alertController = UIAlertController(title: "Change Password", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
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
        guard currentPassword == user.password else {
            self.present(Utility.getFailAlertController(message: wrongPassword), animated: true, completion: nil)
            return
        }
        guard Utility.isValidPassword(testStr: newPassword) else {
            self.present(Utility.getFailAlertController(message: passwordInvalid), animated: true, completion: nil)
            return
        }
        let _ = user.setPassword(newPassword: newPassword)
        let _ = Storage.saveUser(user: user)
        System.updateActiveUser()
        self.present(Utility.getSuccessAlertController(), animated: true, completion: nil)
    }

}
