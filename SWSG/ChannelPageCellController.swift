//
//  ChannelPageCellController.swift
//  SWSG
//
//  Created by Jeremy Jee on 12/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

/**
 ChannelPageCellController is a UIViewController that is used as a single
 cell in the widget of the Latest Chats in HomeViewController as part of the
 ChannelPageViewController
 */
class ChannelPageCellController: UIViewController {
    
    @IBOutlet var channelView: UIView!
    @IBOutlet weak var iconIV: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var messageTV: UITextView!
}
