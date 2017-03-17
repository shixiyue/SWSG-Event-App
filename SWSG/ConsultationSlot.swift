//
//  ConsultationSlot.swift
//  SWSG
//
//  Created by Jeremy Jee on 14/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation

struct ConsultationSlot {
    var startDateTime: Date
    var duration: Int
    var status: ConsultationSlotStatus
    var team: Team?
    
    init(start date: Date, duration: Int, status: ConsultationSlotStatus) {
        self.startDateTime = date
        self.duration = duration
        self.status = status
        self.team = nil
    }
}
