//
//  ProfileTableViewCell.swift
//  SWSG
//
//  Created by shixiyue on 17/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet private var field: UILabel!
    @IBOutlet private var content: UILabel!
    
    func setUp(field: String, content: String) {
        self.field.text = field
        self.content.text = content
    }

}
