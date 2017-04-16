//
//  TeamLookingForTableViewCell.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/22/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

/**
 TeamLookingForTableViewCell inherits from UITableViewCell, it is responsible for displaying the 
 skills that the team is looking for
 
 -Parameter: `lookingForLbl` is a mutable object representing the skills that the team is looking for
 */

import UIKit

class TeamLookingForTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lookingForLbl: UILabel!

}
