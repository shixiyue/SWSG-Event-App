//
//  LoginViewController.swift
//  SWSG
//
//  Created by shixiyue on 11/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

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
        
        System.client.signIn(email: email, password: password, completion: { (error) in
            if let firebaseError = error {
                self.present(Utility.getFailAlertController(message: firebaseError.errorMessage), animated: true, completion: nil)
            } else {
                System.client.getCurrentUser(completion: { (user, userError) in
                    if let firebaseError = userError, user == nil {
                        self.present(Utility.getFailAlertController(message: firebaseError.errorMessage), animated: true, completion: nil)
                    } else {
                        Utility.logInUser(user: user!, currentViewController: self)
                    }
                })
            }
        })
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
