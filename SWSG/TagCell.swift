//
//  TagCell.swift
//  SWSG
//
//  Created by Li Xiaowei on 4/5/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class TagCell: UICollectionViewCell {
    @IBOutlet weak var tagName: UILabel!
    @IBOutlet weak var tagNameMaxWidthConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        self.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        self.tagName.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        self.layer.cornerRadius = 4
        self.tagNameMaxWidthConstraint.constant = UIScreen.main.bounds.width - 8 * 2 - 8 * 2
        self.contentView.autoresizingMask = UIViewAutoresizing.flexibleHeight
    }
    override func layoutSubviews() {
        self.layoutIfNeeded()
    }
    
    func preferredLayoutSizeFittingSize(targetSize: CGSize)-> CGSize {
    
    let originalFrame = self.frame
    let originalPreferredMaxLayoutWidth = self.tagName.preferredMaxLayoutWidth
    
    
    var frame = self.frame
    frame.size = targetSize
    self.frame = frame
    
    self.setNeedsLayout()
    self.layoutIfNeeded()
   // self.label.preferredMaxLayoutWidth = self.questionLabel.bounds.size.width
    
    
    // calling this tells the cell to figure out a size for it based on the current items set
    let computedSize = self.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
    
    let newSize = CGSize(width:targetSize.width, height:computedSize.height)
    
    self.frame = originalFrame
    self.tagName.preferredMaxLayoutWidth = originalPreferredMaxLayoutWidth
    
    return newSize
    }
}
