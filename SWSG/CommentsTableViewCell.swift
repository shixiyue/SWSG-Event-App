//
//  CommentsTableViewCell.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/16/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

/**
 CommentsTableViewCell display the comments created by user, it inherits from UITableViewCell 
 */

import UIKit

class CommentsTableViewCell: UITableViewCell {

    @IBOutlet weak var commentsLabel: UILabel!    
    @IBOutlet weak var profileIV: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
}
