//
//  ConsultationSlotStatus.swift
//  SWSG
//
//  Created by Jeremy Jee on 14/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation

/**
 ConsultationSlotStatus is an enum that represents the status of a ConsultationSlot
 
 Specifications:
 - vacant: Slot is vacant and can be booked
 - booked: Slot has been booked by a team
 - unavailable: Slot has been marked by the Mentor as unavailable and cannot be booked
 */
enum ConsultationSlotStatus: String {
    case vacant
    case booked
    case unavailable
}
