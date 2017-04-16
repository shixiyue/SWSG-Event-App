//
//  TeamItemTableViewCell.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/18/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

/**
 TeamItemTableViewCell inherits from UITableViewCell, it represents the team's name, looking for skills, 
 and member images.
 */

import UIKit

class TeamItemTableViewCell: UITableViewCell {

    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var teamIsLookingFor: UILabel!
    
    @IBOutlet weak var mmbrImage1: UIImageView!
    @IBOutlet weak var mmbrImage2: UIImageView!
    @IBOutlet weak var mmbrImage3: UIImageView!
    @IBOutlet weak var mmbrImage4: UIImageView!


}
