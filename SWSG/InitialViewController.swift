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
    @IBOutlet weak var socialMediaView: UIView!
    
    fileprivate let loginButton = LoginButton(readPermissions: [.publicProfile, .email])
    fileprivate let client = System.client
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.center = socialMediaView.center
        loginButton.delegate = self
        self.view.addSubview(loginButton)
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
        
        if let user = sender as? FBUser {
            guard let signUpVC = segue.destination as? SignUpViewController else {
                return
            }
            
            signUpVC.fbUser = user
        }
    }
}

extension InitialViewController: LoginButtonDelegate {
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult){
        client.getFBProfile(completion: { (user, error) in
            loginButton.isHidden = true
            if let user = user {
                Utility.checkExistingEmail(email: user.email, client: Config.fbIdentifier, viewController: self, completion: { (arr) in
                    if let arr = arr {
                        switch arr[0] {
                        case Config.fbIdentifier:
                            if let current = AccessToken.current {
                                let credential = FIRFacebookAuthProvider.credential(withAccessToken: current.authenticationToken)
                                System.client.signIn(credential: credential, completion: { (error) in
                                    Utility.logUserIn(error: error, current: self)
                                })
                            }
                            
                        default:
                            LoginManager().logOut()
                            self.performSegue(withIdentifier: Config.initialToSignUp, sender: nil)
                        }
                    } else {
                        self.performSegue(withIdentifier: Config.initialToSignUp, sender: user)
                    }
                })
            }
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton){
        
    }
}

