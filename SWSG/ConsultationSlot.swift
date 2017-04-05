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
    var status: ConsultationSlotStatus
    var team: Int
    
    init(start date: Date, status: ConsultationSlotStatus) {
        self.startDateTime = date
        self.status = status
        self.team = -1
    }
    
    init?(snapshot: [String: Any], at startDateTime: Date) {
        self.startDateTime = startDateTime
        
        guard let team = snapshot[Config.team] as? Int else {
            return nil
        }
        self.team = team
        
        guard let statusSnapshot = snapshot[Config.consultationStatus] as? String,
            let status = ConsultationSlotStatus(rawValue: statusSnapshot) else {
            return nil
        }
        self.status = status
    }
    
    func toDictionary() -> [String: Any] {
        return [Config.team: team, Config.consultationStatus: status.rawValue]
    }
}
