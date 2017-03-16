//
//  Mentor.swift
//  SWSG
//
//  Created by Jeremy Jee on 14/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation

class Mentor {
    var profile: Profile
    var days = [ConsultationDate]()
    
    init(profile: Profile) {
        self.profile = profile
    }
    
    func addSlots(on date: Date) {
        var day = ConsultationDate(on: date)
        
        var slotTime = Date.dateTime(forDate: date, forTime: Constants.consultationStartTime)
        let endTime = Date.dateTime(forDate: date, forTime: Constants.consultationEndTime)
        
        while slotTime <= endTime {
            let slot = ConsultationSlot(start: slotTime, duration: Constants.duration,
                                        status: .vacant)
            
            day.slots.append(slot)
            
            slotTime = slotTime.add(minutes: Constants.duration)
        }
        
        days.append(day)
    }
}
