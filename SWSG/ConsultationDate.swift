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
    
    func toDictionary() -> [String: Any] {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        
        formatter.dateFormat = "d/MM/YYYY"
        
        var dict = [[String: Any]]()
        
        for slot in slots {
            dict.append(slot.toDictionary())
        }
        
        return [formatter.string(from: date): dict]
    }
}
