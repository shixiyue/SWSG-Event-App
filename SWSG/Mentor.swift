//
//  Mentor.swift
//  SWSG
//
//  Created by Jeremy Jee on 14/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation

class Mentor {
    var days = [ConsultationDate]()
    var field: Field
    
    init(field: Field) {
        self.field = field
    }
    
    init?(snapshot: [String: Any]) {
        guard let field = snapshot[Config.field] as? String else {
            return nil
        }
        self.field = Field(rawValue: field)!
        
        guard let daysArr = snapshot[Config.consultationDays] as? [String: Any] else {
            return nil
        }
        
        for day in daysArr.keys {
            guard let date = Utility.fbDateFormatter.date(from: day),
                let dateSnapshot = daysArr[day] as? [String: Any],
                let consultationDate = ConsultationDate(snapshot: dateSnapshot, at: date) else {
                    return nil
            }
            self.days.append(consultationDate)
        }
        self.days = self.days.sorted(by: { $0.date < $1.date })
    }
    
    func addSlots(on date: Date) {
        var day = ConsultationDate(on: date)
        
        var slotTime = Date.dateTime(forDate: date, forTime: Config.consultationStartTime)
        let endTime = Date.dateTime(forDate: date, forTime: Config.consultationEndTime)
        
        while slotTime <= endTime {
            let slot = ConsultationSlot(start: slotTime, status: .vacant)
            
            day.slots.append(slot)
            
            slotTime = slotTime.add(minutes: Config.duration)
        }
        
        days.append(day)
    }
    
    func toDictionary() -> [String: Any] {
        var dict = [String: Any]()
        
        for day in days {
            dict[Utility.fbDateFormatter.string(from: day.date)] = day.toDictionary()
        }
        
        return [Config.consultationDays: dict, Config.field: field.rawValue]
    }
}
