//
//  CalendarCell.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/27/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

/**
 CalendarCell inherits from JTAppleDayCell, it represents a single day on the calendar
 
 -parameters:
     -`dayLabel`: a mutable object representing the date
     -`selectedView`: a mutable object to handle day selection and highlight
     - `dot`: a mutable object which is visible only if there is event on that date
 */

import JTAppleCalendar

class CalendarCell: JTAppleDayCellView {
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var selectedView: UIView!
    @IBOutlet var dot: UIView!
}
