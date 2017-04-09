//
//  LoginViewController.swift
//  SWSG
//
//  Created by shixiyue on 11/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import Firebase
import Google
import GoogleSignIn

class LoginViewController: UIViewController {

    @IBOutlet fileprivate var emailTextField: UITextField!
    @IBOutlet fileprivate var passwordTextField: UITextField!
    @IBOutlet fileprivate var logInButton: RoundCornerButton!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var facebookView: UIView!
    @IBOutlet weak var googleView: UIView!
    @IBOutlet weak var signUpView: UIView!
    
    var newCredential: FIRAuthCredential?
    var clientArr: [String]?
    fileprivate let fbLoginButton = LoginButton(readPermissions: [.publicProfile, .email])
    fileprivate let googleLoginButton = GIDSignInButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButton()
        setUpTextFields()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        setUpClients()
    }
    
    private func setUpClients() {
        if let clientArr = clientArr {
            if !clientArr.contains(AuthType.email.rawValue) {
                emailView.isHidden = true
            }
            
            if !clientArr.contains(AuthType.facebook.rawValue) {
                fbLoginButton.isHidden = true
            }
            
            if !clientArr.contains(AuthType.google.rawValue) {
                googleLoginButton.isHidden = true
            }
            
            signUpView.isHidden = true
        }
    }

    private func setUpTextFields() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func setUpButton() {
        logInButton.setDisable()
        logInButton.addTarget(self, action: #selector(logIn), for: .touchUpInside)
        
        let fbCenter = CGPoint(x: facebookView.frame.width/2,y: facebookView.frame.height/2)
        let googleCenter = CGPoint(x: googleView.frame.width/2,y: googleView.frame.height/2)
        
        fbLoginButton.center = fbCenter
        googleLoginButton.center = googleCenter
        
        fbLoginButton.delegate = self
        self.facebookView.addSubview(fbLoginButton)
        
        googleLoginButton.center = googleView.center
        self.googleView.addSubview(googleLoginButton)
    }
    
    @objc fileprivate func logIn() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        
        System.client.signIn(email: email, password: password, completion: { (error) in
            if let credential = self.newCredential {
                System.client.addAdditionalAuth(credential: credential, completion: { _ in
                })
            }
            
            Utility.logUserIn(error: error, current: self)
            
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
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == Config.logInSignUp, let user = sender as? SocialUser {
            guard let signUpVC = segue.destination as? SignUpViewController else {
                return
            }
            
            signUpVC.socialUser = user
        }
    }
    
    fileprivate func attemptLogin(email: String, user: SocialUser, auth: AuthType) {
        Utility.attemptRegistration(email: email, auth: auth, newCredential: self.newCredential, viewController: self, completion: { (exists, arr) in
            
            if !exists, let _ = arr {
                let title = "Already Exists"
                let message = "User with Email already exists, please log in with the original client first."
                Utility.displayDismissivePopup(title: title, message: message, viewController: self, completion: { _  in
                    //self.performSegue(withIdentifier: Config.showLogin, sender: arr)
                })
                
                //TODO: Pass existing login on.
            } else if arr == nil {
                //Account does not exist, proceed with registration
                self.performSegue(withIdentifier: Config.logInSignUp, sender: user)
            }
        })
    }
    
}

extension LoginViewController: UITextFieldDelegate {
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

extension LoginViewController: GIDSignInDelegate, GIDSignInUIDelegate {
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            let user = SocialUser(gUser: user)
            self.attemptLogin(email: user.email, user: user, auth: .google)
        }
    }
}

extension LoginViewController: LoginButtonDelegate {
    
    func loginButtonDidCompleteLogin(_ fbLoginButton: LoginButton, result: LoginResult){
        System.client.getFBProfile(completion: { (user, error) in
            fbLoginButton.isHidden = true
            guard let user = user else {
                return
            }
            
            self.attemptLogin(email: user.email, user: user, auth: .facebook)
        })
    }
    
    func loginButtonDidLogOut(_ fbLoginButton: LoginButton){
        
    }
}
