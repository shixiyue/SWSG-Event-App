//
//  UserTypes.swift
//  SWSG
//
//  Created by shixiyue on 11/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation

/**
 UserTypes represents the type of the user, and supports multiple user types
 
 Specifications:
 - isParticipant
 - isSpeaker
 - isMentor
 - isOrganizer
 - isAdmin
 */
struct UserTypes {
    
    let isParticipant: Bool
    let isSpeaker: Bool
    let isMentor: Bool
    let isOrganizer: Bool
    let isAdmin: Bool
    
    init(isParticipant: Bool = false, isSpeaker: Bool = false, isMentor: Bool = false, isOrganizer: Bool = false, isAdmin: Bool = false) {
        self.isParticipant = isParticipant
        self.isSpeaker = isSpeaker
        self.isMentor = isMentor
        self.isOrganizer = isOrganizer
        self.isAdmin = isAdmin
        
        _checkRep()
    }
    
    private func _checkRep() {
        #if DEBUG
        assert(isParticipant || isSpeaker || isMentor || isOrganizer || isAdmin)
        #endif
    }
    
    func toDictionary() -> [String: Bool] {
        return [Config.isParticipant: isParticipant, Config.isSpeaker: isSpeaker, Config.isMentor: isMentor, Config.isOrganizer: isOrganizer, Config.isAdmin: isAdmin]
    }
    
    func toString () -> String {
        var string = ""
        if isParticipant {
            string += "Participant "
        }
        if isSpeaker {
            string += "Speaker "
        }
        if isMentor {
            string += "Mentor "
        }
        if isOrganizer {
            string += "Organizer "
        }
        if isAdmin {
            string += "Admin "
        }
        return string
    }
    
}
