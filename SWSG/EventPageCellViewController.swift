//
//  EventPageCellViewController.swift
//  SWSG
//
//  Created by Jeremy Jee on 11/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

/**
    EventPageCellViewController is a UIViewController that is used as a single
    cell in the widget of the Latest Events in HomeViewController as part of the
    EventPageViewController
 */
class EventPageCellViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var colorBorder: UIView!
    @IBOutlet weak var imageIV: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var venueLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var descTV: UITextView!
}
