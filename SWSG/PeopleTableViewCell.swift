//
//  SpeakersTableViewCell.swift
//  SWSG
//
//  Created by Shi Xiyue on 26/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

/**
 PeopleTableViewCell is a UITableViewCell that is used in PeopleViewController
 to display information about a person.
 
 It has a Name Label, a Photo Image View, a Title Label, and an Intro Label.
 */
class PeopleTableViewCell: UITableViewCell {

    @IBOutlet private var photo: UIImageView!
    @IBOutlet private var name: UILabel!
    @IBOutlet private var title: UILabel!
    @IBOutlet private var intro: UILabel!
    
    func setUp(person: Person) {
        self.photo.image = person.photo
        self.name.text = person.name
        self.title.text = person.title
        self.intro.text = person.intro
    }
    
    override func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        self.photo.isUserInteractionEnabled = true
        photo.addGestureRecognizer(gestureRecognizer)
    }
    
}
