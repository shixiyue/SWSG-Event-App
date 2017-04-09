//
//  ViewController.swift
//  SWSG
//
//  Created by Jeremy Jee on 9/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import Firebase
import FacebookCore
import FacebookLogin
import GoogleSignIn

/// `InitialViewController` represents the view controller for initial screen, which will prompt the user to sign up / log in.
class InitialViewController: UIViewController {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var fbView: UIView!
    @IBOutlet weak var googleView: UIView!
    
    fileprivate let fbLoginButton = LoginButton(readPermissions: [.publicProfile, .email])
    fileprivate let googleLoginButton = GIDSignInButton()
    fileprivate let client = System.client
    fileprivate var currentAuth: AuthType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fbLoginButton.center = fbView.center
        fbLoginButton.delegate = self
        
        googleLoginButton.center = googleView.center
        
        self.stackView.addSubview(fbLoginButton)
        self.stackView.addSubview(googleLoginButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        fbLoginButton.isHidden = false
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        if AccessToken.current != nil {
            LoginManager().logOut()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == Config.signUpToLogin, let arr = sender as? [String] {
            guard let loginVC = segue.destination as? LoginViewController,
                let auth = currentAuth else {
                return
            }
            
            switch auth {
            case .facebook:
                loginVC.newCredential = client.getFBCredential()
            case .google:
                loginVC.newCredential = client.getGoogleCredential()
            default:
                break
            }
            
            loginVC.clientArr = arr
        } else if segue.identifier == Config.initialToSignUp, let user = sender as? SocialUser {
            guard let signUpVC = segue.destination as? SignUpViewController else {
                return
            }
            
            signUpVC.socialUser = user
        }
    }
    
    fileprivate func displayErrorMsg() {
        let title = "An error has occured"
        let message = "Please try again"
        Utility.displayDismissivePopup(title: title, message: message, viewController: self, completion: { _  in
        })
    }
    
    fileprivate func attemptLogin(email: String, user: SocialUser, auth: AuthType) {
        Utility.attemptRegistration(email: email, auth: auth, newCredential: nil, viewController: self, completion: { (exists, arr) in
            
            print(exists)
            if !exists, let arr = arr {
                let title = "Already Exists"
                let message = "User with Email already exists, please log in with the original client first."
                Utility.displayDismissivePopup(title: title, message: message, viewController: self, completion: { ()  in
                    self.currentAuth = auth
                    self.performSegue(withIdentifier: Config.initialToLogin, sender: arr)
                    
                })
                
                //TODO: Pass existing login on.
            } else if arr == nil {
                //Account does not exist, proceed with registration
                self.performSegue(withIdentifier: Config.initialToSignUp, sender: user)
            }
        })
    }
}

extension InitialViewController: GIDSignInDelegate, GIDSignInUIDelegate {
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            let user = SocialUser(gUser: user)
            self.attemptLogin(email: user.email, user: user, auth: .google)
        } else {
            self.displayErrorMsg()
        }
    }
}

extension InitialViewController: LoginButtonDelegate {
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult){
        client.getFBProfile(completion: { (user, error) in
            self.fbLoginButton.isHidden = true
            guard let user = user else {
                self.displayErrorMsg()
                return
            }
            
            self.attemptLogin(email: user.email, user: user, auth: .facebook)
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton){
        
    }
}

