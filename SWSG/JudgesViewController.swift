//
//  SpeakersViewController.swift
//  SWSG
//
//  Created by Shi Xiyue on 26/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class JudgesViewController: PeopleViewController {

    @IBOutlet private var judgesTableView: UITableView!
    
    override var people: [(name: String, title: String, intro: String, photo: String)] { return JudgesInfo.judegs }
    override var header: String { return "Judges" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView(judgesTableView)
    }

}

