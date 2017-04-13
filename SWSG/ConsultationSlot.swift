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
    var team: String?
    
    init(start date: Date, status: ConsultationSlotStatus) {
        self.startDateTime = date
        self.status = status
    }
    
    init?(snapshot: [String: Any], at startDateTime: Date) {
        self.startDateTime = startDateTime
        
        if let team = snapshot[Config.team] as? String {
            self.team = team
        }
        
        guard let statusSnapshot = snapshot[Config.consultationStatus] as? String,
            let status = ConsultationSlotStatus(rawValue: statusSnapshot) else {
            return nil
        }
        self.status = status
    }
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [Config.consultationStatus: status.rawValue]
        
        if let team = team {
            dict[Config.team] = team
        }
        
        return dict
    }
}
