//
//  ConsultationDay.swift
//  SWSG
//
//  Created by Jeremy Jee on 16/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation

struct ConsultationDate {
    var date: Date
    var slots: [ConsultationSlot]
    
    init(on date: Date) {
        self.date = date
        self.slots = [ConsultationSlot]()
    }
}
