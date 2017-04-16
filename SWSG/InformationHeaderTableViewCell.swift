//
//  InformationHeaderTableViewCell.swift
//  SWSG
//
//  Created by Shi Xiyue on 26/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

/**
 InformationHeaderCell is a UITableViewCell that is used in multiple view controllers,
 to display what category does the information belong to.
 
 It has a Header Label.
 */
class InformationHeaderTableViewCell: UITableViewCell {

    @IBOutlet private var informationHeader: UILabel!
    
    func setHeader(_ text: String) {
        informationHeader.text = text
    }

}
