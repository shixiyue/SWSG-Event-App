//
//  ParticipantRegistrationViewController.swift
//  SWSG
//
//  Created by Jeremy Jee on 13/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import QRCode

class ParticipantRegistrationViewController: UIViewController {
    
    @IBOutlet weak var qrCodeIV: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let activeUser = System.activeUser else {
            return
        }
        
        let username = activeUser.profile.username
        
        guard let qrCode = QRCode(username) else {
            return
        }
        
        qrCodeIV.image = qrCode.image
    }
}
