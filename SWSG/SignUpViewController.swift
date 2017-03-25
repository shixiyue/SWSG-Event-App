//
//  SignUpViewController.swift
//  SWSG
//
//  Created by shixiyue on 13/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet private var signUpButton: RoundCornerButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Config.signUpTable, let signUpTableViewController = segue.destination as? SignUpTableViewController else {
            return
        }
        signUpTableViewController.signUpButton = signUpButton
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseClient.signUp(email: "vietthang207@gmail.com", password: "123456")
        FirebaseClient.signIn(email: "vietthang207@gmail.com", password: "123456")
        FirebaseClient.createNewUser(email: "vietthang207@gmail.com", password: "123456")
    }

}
