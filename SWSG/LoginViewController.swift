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
import SwiftSpinner

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
    fileprivate var currentAuth: AuthType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButton()
        setUpTextFields()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SwiftSpinner.hide()
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        setUpClients()
        Utility.signOutAllAccounts()
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
        
        fbLoginButton.delegate = self
        self.facebookView.addSubview(fbLoginButton)
        
        googleLoginButton.center = googleCenter
        self.googleView.addSubview(googleLoginButton)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(googleLoginBtnPressed))
        googleLoginButton.addGestureRecognizer(tapGesture)
    }
    
    @objc fileprivate func logIn() {
        guard System.client.isConnected else {
            present(Utility.getNoInternetAlertController(), animated: true, completion: nil)
            return
        }
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        
        attemptLogin(email: email, password: password, user: nil, auth: .email)
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
        
        if segue.identifier == Config.loginToSignup, let user = sender as? SocialUser {
            guard let signUpVC = segue.destination as? SignUpViewController else {
                return
            }
            
            signUpVC.socialUser = user
        } else if segue.identifier == Config.loginToLogin, let arr = sender as? [String] {
            guard let loginVC = segue.destination as? LoginViewController,
                let auth = currentAuth else {
                    return
            }
            
            switch auth {
            case .facebook:
                loginVC.newCredential = System.client.getFBCredential()
            case .google:
                loginVC.newCredential = System.client.getGoogleCredential()
            case .email:
                loginVC.newCredential = System.client
                    .getEmailCredential(email: emailTextField.text,
                                        password: passwordTextField.text)
            }
            
            loginVC.clientArr = arr
        }
    }
    
    fileprivate func attemptLogin(email: String, password: String?, user: SocialUser?, auth: AuthType) {
        Utility.attemptRegistration(email: email, password: password, auth: auth, newCredential: self.newCredential, viewController: self, completion: { (exists, arr) in
            
            if !exists, let _ = arr {
                let title = "Already Exists"
                let message = "User with Email already exists, please log in with the original client first."
                Utility.displayDismissivePopup(title: title, message: message, viewController: self, completion: { _  in
                    self.currentAuth = auth
                    self.performSegue(withIdentifier: Config.loginToLogin, sender: arr)
                })
                
            } else if arr == nil {
                //Account does not exist, proceed with registration
                self.performSegue(withIdentifier: Config.loginToSignup, sender: user)
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
    func googleLoginBtnPressed(sender: UITapGestureRecognizer) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            SwiftSpinner.show("Communicating with Google")
            let user = SocialUser(gUser: user)
            self.attemptLogin(email: user.email, password: nil, user: user, auth: .google)
        }
    }
}

extension LoginViewController: LoginButtonDelegate {
    
    func loginButtonDidCompleteLogin(_ fbLoginButton: LoginButton, result: LoginResult){
        System.client.getFBProfile(completion: { (user, error) in
            guard let user = user else {
                return
            }
            
            SwiftSpinner.show("Communicating with Facebook")
            self.attemptLogin(email: user.email, password: nil, user: user, auth: .facebook)
        })
    }
    
    func loginButtonDidLogOut(_ fbLoginButton: LoginButton){
        
    }
}
