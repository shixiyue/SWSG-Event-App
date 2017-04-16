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

/**
    LoginViewController is a UIViewController that displays the Log In Screen
    
    Specifications:
        - newCredential: Credential if the User already has an account and is attempting to
                         login from a new Authentication Provider
        - clientArr:     Array of Authentication Providers that the User has logged
                         in with before.
 */
class LoginViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet fileprivate var emailTextField: UITextField!
    @IBOutlet fileprivate var passwordTextField: UITextField!
    @IBOutlet fileprivate var logInButton: RoundCornerButton!
    @IBOutlet private var stackView: UIStackView!
    @IBOutlet private var emailView: UIView!
    @IBOutlet private var facebookView: UIView!
    @IBOutlet private var googleView: UIView!
    @IBOutlet private var signUpView: UIView!
    
    // MARK: Properties
    var newCredential: FIRAuthCredential?
    var clientArr: [String]?
    fileprivate let fbLoginButton = LoginButton(readPermissions: [.publicProfile, .email])
    fileprivate let googleLoginButton = GIDSignInButton()
    fileprivate var currentAuth: AuthType?
    
    // MARK: Intialization Functions
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
    
    private func setUpTextFields() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func setUpButton() {
        logInButton.setDisable()
        logInButton.addTarget(self, action: #selector(logIn), for: .touchUpInside)
        
        let fbCenter = CGPoint(x: facebookView.frame.width/2,
                               y: facebookView.frame.height/2)
        let googleCenter = CGPoint(x: googleView.frame.width/2,
                                   y: googleView.frame.height/2)
        
        fbLoginButton.center = fbCenter
        fbLoginButton.delegate = self
        self.facebookView.addSubview(fbLoginButton)
        
        googleLoginButton.center = googleCenter
        self.googleView.addSubview(googleLoginButton)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(googleLoginBtnPressed))
        googleLoginButton.addGestureRecognizer(tapGesture)
    }
    
    private func setUpClients() {
        guard let clientArr = clientArr else {
            return
        }
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
    
    fileprivate func attemptLogin(email: String, password: String?, user: SocialUser?, auth: AuthType) {
        Utility.attemptRegistration(email: email, password: password, auth: auth,
                                    newCredential: self.newCredential,
                                    viewController: self,
                                    completion: { (exists, arr) in
            
            if !exists, let _ = arr {
                let title = Config.emailExists
                let message = Config.logInWithOriginal
                SwiftSpinner.show(title, animated: false).addTapHandler({
                    SwiftSpinner.hide({
                        self.currentAuth = auth
                        self.performSegue(withIdentifier: Config.initialToLogin, sender: arr)
                    })
                }, subtitle: message)
            } else if arr == nil {
                //Account does not exist, proceed with registration
                self.performSegue(withIdentifier: Config.loginToSignup, sender: user)
            }
        })
    }
    
}

// MARK: UITextFieldDelegate
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateButtonState()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        updateButtonState()
    }
    
    // MARK: UI Supporting Method
    private func updateButtonState() {
        let isAnyEmpty = emailTextField.text?.isEmpty ?? true || passwordTextField.text?.isEmpty ?? true
        logInButton.isEnabled = !isAnyEmpty
        logInButton.alpha = isAnyEmpty ? Config.disableAlpha : Config.enableAlpha
    }
    
}

// MARK: GIDSignInDelegate, GIDSignInUIDelegate
extension LoginViewController: GIDSignInDelegate, GIDSignInUIDelegate {
    func googleLoginBtnPressed(sender: UITapGestureRecognizer) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            Utility.showSwiftSpinnerErrorMsg()
            return
        }
        SwiftSpinner.show(Config.communicateGoogle)
        let user = SocialUser(gUser: user)
        attemptLogin(email: user.email, password: nil, user: user, auth: .google)
    }
    
}

// MARK: LoginButtonDelegate
extension LoginViewController: LoginButtonDelegate {
    
    func loginButtonDidCompleteLogin(_ fbLoginButton: LoginButton, result: LoginResult) {
        System.client.getFBProfile(completion: { (user, _) in
            guard let user = user else {
                return
            }
            
            SwiftSpinner.show(Config.communicateFacebook)
            self.attemptLogin(email: user.email, password: nil, user: user, auth: .facebook)
        })
    }
    
    func loginButtonDidLogOut(_ fbLoginButton: LoginButton) {
        
    }
}
