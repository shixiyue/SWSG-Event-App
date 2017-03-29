//
//  SpeakersViewController.swift
//  SWSG
//
//  Created by Shi Xiyue on 26/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class OrganizersViewController: PeopleViewController {

    @IBOutlet private var organizersTableView: UITableView!
    
    override var people: [(name: String, title: String, intro: String, photo: String)] { return OrganizersInfo.organizers }
    override var header: String { return "Organizing Team" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView(organizersTableView)
    }

}

