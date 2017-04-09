//
//  EventScheduleTableViewCell.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/15/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class EventScheduleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var colorBorder: UIView!
    @IBOutlet weak var eventIV: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventTimeVenue: UILabel!
    @IBOutlet weak var eventDescription: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.eventDescription.textContainer.lineFragmentPadding = 0
        self.eventDescription.textContainerInset = UIEdgeInsets.zero
    }

}
