//
//  SponsorsTitleTableViewCell.swift
//  SWSG
//
//  Created by Shi Xiyue on 27/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class SponsorsTitleTableViewCell: UITableViewCell {

    @IBOutlet private var title: UILabel!
    
    func setTitle(_ title: String) {
        self.title.text = title
    }

}
