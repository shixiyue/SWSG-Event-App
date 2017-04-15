//
//  TeamEditViewController.swift
//  SWSG
//
//  Created by Li Xiaowei on 4/14/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class TeamEditViewController: UIViewController {
    
    var team: Team?
    var delegate: TeamEditDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onDoneBtnPressed(_ sender: Any) {
        guard let delegate = delegate else {
            return
        }
        if delegate.updateTeamValue() {
           Utility.popViewController(no: 1, viewController: self)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
