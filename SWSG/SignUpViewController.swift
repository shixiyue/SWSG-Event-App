//
//  SignUpViewController.swift
//  SWSG
//
//  Created by shixiyue on 13/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import SwiftSpinner

/**
    SignUpViewController is a UIViewController that displays SignUpTableViewController
    as an embedded view.
 
 
    Specifications:
      - socialUser: Existing Details from a Social Media Login, an optional value
                    Details would be used to fill Name, Email and Profile Image
 */
class SignUpViewController: UIViewController {
    
    @IBOutlet weak var loginStack: UIStackView!
    @IBOutlet private var signUpButton: RoundCornerButton!
    
    public var socialUser: SocialUser?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Config.signUpTable, let signUpTableViewController = segue.destination as? SignUpTableViewController else {
            return
        }
        signUpTableViewController.socialUser = socialUser
        signUpTableViewController.signUpButton = signUpButton
        signUpTableViewController.loginStack = loginStack
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let noti = PushNotification(type: .announcement, additionData: ["foo": "bar"], message: "one to rule")
        let pusher = NotiPusher()
        pusher.pushToAll(noti: noti)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SwiftSpinner.hide()
    }

}
