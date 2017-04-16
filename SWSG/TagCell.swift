//
//  TagCell.swift
//  SWSG
//
//  Created by Li Xiaowei on 4/5/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

/**
 TagCell inherits from UICollectionViewCell class, it displays a single tag message
 
 -Parameters:
     - `tagName`: represents a skill label
     - `tagNameMaxWidthConstraint`: maximum width constraint used for auto-size the collection cell width
     - `delete`: delete button which handles the deletion of a tag
 */

import UIKit

class TagCell: UICollectionViewCell {
    
    @IBOutlet weak var tagName: UILabel!
    @IBOutlet weak var tagNameMaxWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var delete: UIButton!
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        self.tagName.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        self.layer.cornerRadius = 4
        self.tagNameMaxWidthConstraint.constant = UIScreen.main.bounds.width - 8 * 2 - 8 * 2
        self.contentView.autoresizingMask = UIViewAutoresizing.flexibleHeight
    }

    override func layoutSubviews() {
        self.layoutIfNeeded()
        bringSubview(toFront: delete)
    }
}
