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

extension Team {
    func toDictionary() -> [String: Any] {
        var data = [String: Any]()
        var member_data = [[String: Any]]()
        for each_member in members {
            var user_data = each_member.toDictionary()
            user_data.updateValue(each_member.team as Any , forKey: "team")
            member_data.append(user_data)
        }
        data.updateValue(member_data, forKey: "members")
        data.updateValue(name, forKey: "teamName")
        data.updateValue(info, forKey: "info")
        data.updateValue(lookingFor ?? "", forKey: "lookingFor")
        data.updateValue(isPrivate, forKey: "isPrivate")
        return data
    }
}
