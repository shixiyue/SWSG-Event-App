//
//  MenuCell.swift
//  SWSG
//
//  Created by Jeremy Jee on 14/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

/**
 IdeaItemCell is a UITableViewCell that is used in InformationViewController
 to display a category of information
 
 It has a Name Label and an Icon Image View.
 */
class InformationCell: UITableViewCell {
    
    // MARK: IBOutlets
    @IBOutlet private var icon: UIImageView!
    @IBOutlet private var name: UILabel!
    
    func setUp(name: String, icon: String) {
        self.icon.image = UIImage(named: icon)
        self.name.text = name
    }
    
}
