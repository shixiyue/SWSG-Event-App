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
    var slots = [ConsultationSlot]()
    
    init(on date: Date) {
        self.date = date
    }
    
    init?(snapshot: [String: Any], at date: Date) {
        self.date = date
        for key in snapshot.keys {
            guard let slotDateTime = Utility.fbDateTimeFormatter.date(from: key),
                let slot = snapshot[key] as? [String: Any] else {
                return nil
            }
            self.slots.append(ConsultationSlot(snapshot: slot, at: slotDateTime)!)
        }
    }
    
    func toDictionary() -> [String: Any] {
        
        var dict = [String: Any]()
        
        for slot in slots {
            dict[Utility.fbDateTimeFormatter.string(from: slot.startDateTime)] = slot.toDictionary()
        }
        
        return dict
    }
}
