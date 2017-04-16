//
//  ConsultationSlot.swift
//  SWSG
//
//  Created by Jeremy Jee on 14/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation

/**
 ConsultationSlot is a struct used to hold details about a Consultation Slot
 for a Mentor within ConsultationDate
 
 Specifications:
 - startDateTime: The Date when the slot starts
 - status: An enum of ConsultationSlotStatus detailing the status of the slot
 - team: If booked, it is the Team ID of the team that booked it
 
 Representation Invariant:
 - If the slot is booked, it should have a team ID
 */
struct ConsultationSlot {
    var startDateTime: Date
    var status: ConsultationSlotStatus {
        willSet(newStatus) {
            _checkRep()
        }
    }
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
        
        _checkRep()
    }
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [Config.consultationStatus: status.rawValue]
        
        if let team = team {
            dict[Config.team] = team
        }
        
        return dict
    }
    
    fileprivate func _checkRep() {
        #if DEBUG
        if status == .booked && team == nil {
            assert(false)
        }
        #endif
    }
}
