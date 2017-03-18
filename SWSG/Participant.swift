//
//  Participant.swift
//  SWSG
//
//  Created by shixiyue on 11/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation

/// `Participant` represents a participant of SWSG. It implements `User` Protocol.
class Participant: NSObject, User {
    
    let type: UserTypes = UserTypes(isParticipant: true)
    let email: String
    public private (set) var profile: Profile
    public internal (set) var password: String
    public private (set) var team: Team?
    
    init(profile: Profile, password: String, email: String, team: Team?) {
        self.profile = profile
        self.password = password
        self.email = email
        self.team = team
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let profile = aDecoder.decodeObject(forKey: Config.profile) as? Profile else {
            return nil
        }
        self.profile = profile
        guard let password = aDecoder.decodeObject(forKey: Config.password) as? String else {
            return nil
        }
        self.password = password
        guard let email = aDecoder.decodeObject(forKey: Config.email) as? String else {
            return nil
        }
        self.email = email
        self.team = aDecoder.decodeObject(forKey: Config.team) as? Team
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encodeUserTypes(type)
        aCoder.encode(profile, forKey: Config.profile)
        aCoder.encode(password, forKey: Config.password)
        aCoder.encode(email, forKey: Config.email)
        guard let team = team else {
            return
        }
        aCoder.encode(team, forKey: Config.team)
    }
    
}