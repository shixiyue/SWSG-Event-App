//
//  ChatCell.swift
//  SWSG
//
//  Created by Jeremy Jee on 23/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

/*
    ChannelCell is a UITableViewCell that is used in ChannelListViewController
    to display information about a Channel
 
    It has an Icon Image View, a Name Label and a Latest Message Text View
 */

class ChannelCell: UITableViewCell {
    @IBOutlet weak var iconIV: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var messageTV: UITextView!
    
}
