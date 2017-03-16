//
//  LoginViewController.swift
//  SWSG
//
//  Created by shixiyue on 11/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    private let emailInvalid = "Please enter a valid email address."
    private let userInvalid = "The email does not match any account."
    private let passwordInvalid = "The email and password do not match."

    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var logInButton: RoundCornerButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButton()
        setUpTextFields()
        hideKeyboardWhenTappedAround()
    }

    private func setUpTextFields() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func setUpButton() {
        logInButton.setDisable()
        logInButton.addTarget(self, action: #selector(logIn), for: .touchUpInside)
    }
    
    @objc private func logIn() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        guard Utility.isValidEmail(testStr: email) else {
            self.present(Utility.getFailAlertController(message: emailInvalid), animated: true, completion: nil)
            return
        }
        guard let user = Storage.readUser(email: email) else {
            self.present(Utility.getFailAlertController(message: userInvalid), animated: true, completion: nil)
            return
        }
        guard password == user.password else {
            self.present(Utility.getFailAlertController(message: passwordInvalid), animated: true, completion: nil)
            return
        }
        Utility.logInUser(user: user, currentViewController: self)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateButtonState()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        updateButtonState()
    }
    
    private func updateButtonState() {
        let isAnyEmpty = emailTextField.text?.isEmpty ?? true || passwordTextField.text?.isEmpty ?? true
        logInButton.isEnabled = !isAnyEmpty
        logInButton.alpha = isAnyEmpty ? Config.disableAlpha : Config.enableAlpha
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            passwordTextField.resignFirstResponder()
            logIn()
        }
        return false
    }
    
}
