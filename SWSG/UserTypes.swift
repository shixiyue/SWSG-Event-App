//
//  UserTypes.swift
//  SWSG
//
//  Created by shixiyue on 11/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation

/// `UserTypes` represents the type of a User. A user can have multiple roles, but cannot don't have any role.
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
        assert(isParticipant || isSpeaker || isMentor || isOrganizer || isAdmin)
    }
    
}
