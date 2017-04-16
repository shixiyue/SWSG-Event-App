//
//  MemberCell.swift
//  SWSG
//
//  Created by Jeremy Jee on 5/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

/**
    MemberCell is a UITableViewCell used in ChannelInforViewController to
    display information about a member of the Channel.

    It has an Icon Image View, and a Name Label.
*/

class MemberCell: UITableViewCell {
    @IBOutlet weak var iconIV: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
}
