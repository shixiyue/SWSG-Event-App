//
//  SpeakersViewController.swift
//  SWSG
//
//  Created by Shi Xiyue on 26/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class SpeakersViewController: PeopleViewController {

    @IBOutlet private var speakersTableView: UITableView!
    
    override var people: [(name: String, title: String, intro: String, photo: String)] { return SpeakersInfo.speakers }
    override var header: String { return "Speakers" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView(speakersTableView)
    }

}

