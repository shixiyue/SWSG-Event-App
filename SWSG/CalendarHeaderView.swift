//
//  CalendarHeaderView.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/28/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

/**
 CalendarHeaderView inherits from JTAppleHeaderView
 
 -parameter:
     -`title`: a mutable object displaying the month and year
 */

import JTAppleCalendar

class CalendarHeaderView : JTAppleHeaderView {
    @IBOutlet var title: UILabel!
}
