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
    private var signUpTableViewController: SignUpTableViewController!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Config.signUpTable, let signUpTableViewController = segue.destination as? SignUpTableViewController else {
            return
        }
        self.signUpTableViewController = signUpTableViewController
        signUpTableViewController.signUpButton = signUpButton
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
