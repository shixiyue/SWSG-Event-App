//
//  TeamEditViewController.swift
//  SWSG
//
//  Created by Li Xiaowei on 4/14/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

/**
 TeamEditViewController inherits from UIViewController, it is reponsible for handling team edits.
 It contains a container view which reuses TeamCreateTableViewController
 
 -Paramters: 
     - `Team`: mutable object which represents the team to be editted
     - `delegate`: mutable object which represents the TeamEditDelegate, which is reponsible to handle any changes made to team object
 
 -SeeAlso: `TeamCreateTableViewController`
 */

import UIKit

class TeamEditViewController: UIViewController {
    
    var team: Team?
    var delegate: TeamEditDelegate?

    /// update any changes made to the team on `Done` button pressed
    @IBAction func onDoneBtnPressed(_ sender: Any) {
        guard let delegate = delegate else {
            return
        }
        if delegate.updateTeamValue() {
           Utility.popViewController(no: 1, viewController: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destVC = segue.destination as? TeamCreateTableViewController else {
            return
        }
        destVC.team = self.team
        self.delegate = destVC
    }
}

protocol TeamEditDelegate: class {
    func updateTeamValue() -> Bool
}
