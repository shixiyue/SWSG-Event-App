//
//  MenuCell.swift
//  SWSG
//
//  Created by Jeremy Jee on 14/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class InformationCell: UITableViewCell {
    
    @IBOutlet private var icon: UIImageView!
    @IBOutlet private var name: UILabel!
    
    func setUp(name: String, icon: String) {
        self.icon.image = UIImage(named: image)
        self.name.text = name
    }
    
}
