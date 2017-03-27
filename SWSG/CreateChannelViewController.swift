//
//  CreateChannelViewController.swift
//  SWSG
//
//  Created by Jeremy Jee on 23/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import Firebase

class CreateChannelViewController: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    
    private lazy var channelRef: FIRDatabaseReference = FIRDatabase.database().reference().child("channels")
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        if let name = nameTF?.text { // 1
            let newChannelRef = channelRef.childByAutoId() // 2
            newChannelRef.child("name").setValue(name)
            newChannelRef.child("members").childByAutoId().setValue(FIRAuth.auth()?.currentUser?.uid)
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
