//
//  ProfileCell.swift
//  SWSG
//
//  Created by Jeremy Jee on 10/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    @IBOutlet private var colorBorder: UIView!
    @IBOutlet private var iconIV: UIImageView!
    @IBOutlet private var nameLbl: UILabel!
    @IBOutlet private var jobLbl: UILabel!
    @IBOutlet private var companyLbl: UILabel!
    @IBOutlet private var teamLbl: UILabel!
    
    func setUp(name: String, job: String, company: String) {
        colorBorder.backgroundColor = Config.themeColor
        iconIV = Utility.roundUIImageView(for: iconIV)
        iconIV.image = Config.placeholderImg
        nameLbl.text = name
        jobLbl.text = job
        companyLbl.text = company
    }
    
    func setTeamLabel(_ teamLblText: String) {
        teamLbl.text = teamLblText
    }
    
    func setIconImage(_ image: UIImage) {
        iconIV.image = image
    }
}
