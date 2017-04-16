//
//  TeamMemberTableViewCell.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/22/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

/**
 TeamMemberTableViewCell inheris from UITableViewCell, it represents a single team member cell
 
 -Parameters: 
     - `nameLbl`: mutable object representing name of a member
     - `jobLbl`: mutable object representing job of a member
     - `companyLbl`: mutable object representing company of a member
     - `descLbl`: mutable object representing description of a member
     - `profileimage`: mutable object representing profile image of a member
 
-SeeAlso: `Team`
 */

import UIKit

class TeamMemberTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var jobLbl: UILabel!
    @IBOutlet weak var companyLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var profileimage: UIImageView!
    
}
