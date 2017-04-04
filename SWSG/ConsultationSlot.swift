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
    var team: Int
    
    init(start date: Date, duration: Int, status: ConsultationSlotStatus) {
        self.startDateTime = date
        self.duration = duration
        self.status = status
        self.team = -1
    }
    
    func toDictionary() -> [String: Any] {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        
        formatter.dateFormat = "d/MM/YYYY HH:mm"
        
        let dict = [Config.team: "\(team)", Config.consultationStatus: status.rawValue]
        
        
        return [formatter.string(from: startDateTime): dict]
    }
}
