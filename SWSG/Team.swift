//
//  Team.swift
//  SWSG
//
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation

/// `Team` represents a team of SWSG.
class Team {
    
    public private (set) var members: [Participant]
    public private (set) var name: String
    public private (set) var info: String
    public private (set) var lookingFor: String?
    public private (set) var isPrivate: Bool
    
    init(members: [Participant], name: String, info: String, lookingFor: String?, isPrivate: Bool) {
        self.members = members
        self.name = name
        self.info = info
        self.lookingFor = lookingFor
        self.isPrivate = isPrivate
    }
    
    func addMember(member: Participant) {
        members.append(member)
    }
}
