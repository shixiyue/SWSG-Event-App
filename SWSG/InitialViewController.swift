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

/// `InitialViewController` represents the view controller for initial screen, which will prompt the user to sign up / log in.
class InitialViewController: UIViewController {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var fbView: UIView!
    @IBOutlet weak var googleView: UIView!
    
    fileprivate let loginButton = LoginButton(readPermissions: [.publicProfile, .email])
    fileprivate let client = System.client
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.center = fbView.center
        loginButton.delegate = self
        self.stackView.addSubview(loginButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        loginButton.isHidden = false
        
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
            guard let loginVC = segue.destination as? LoginViewController else {
                return
            }
            
            loginVC.clientArr = arr
        } else if segue.identifier == Config.initialToSignUp, let user = sender as? FBUser {
            guard let signUpVC = segue.destination as? SignUpViewController else {
                return
            }
            
            signUpVC.fbUser = user
        }
    }
    
    fileprivate func displayErrorMsg() {
        let title = "An error has occured"
        let message = "Please try again"
        Utility.displayDismissivePopup(title: title, message: message, viewController: self, completion: { _  in
        })
    }
}

extension InitialViewController: LoginButtonDelegate {
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult){
        client.getFBProfile(completion: { (user, error) in
            loginButton.isHidden = true
            guard let user = user else {
                self.displayErrorMsg()
                return
            }
            
            Utility.attemptRegistration(email: user.email, client: Config.fbIdentifier, viewController: self, completion: { (exists, arr) in
                
                if exists {
                    //Account for FB already Exists
                    Utility.attemptLogin(client: Config.fbIdentifier, viewController: self, completion: { (success) in
                        
                    })
                } else if let arr = arr {
                    let title = "Already Exists"
                    let message = "User with Email already exists, please log in with the original client first."
                    Utility.displayDismissivePopup(title: title, message: message, viewController: self, completion: { ()  in
                        self.performSegue(withIdentifier: Config.initialToLogin, sender: arr)
                    })
                    
                    //TODO: Pass existing login on.
                } else {
                    //Account does not exist, proceed with registration
                    self.performSegue(withIdentifier: Config.initialToSignUp, sender: user)
                }
            })
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton){
        
    }
}

