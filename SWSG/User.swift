//
//  User.swift
//  SWSG
//
//  Created by shixiyue on 11/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation
import Firebase

/// `User` represents a User of SWSG App.
class User {
    
    let email: String
    public private (set) var profile: Profile
    public private (set) var type: UserTypes
    public private (set) var team = Config.noTeam
    public private (set) var mentor: Mentor?
    
    init(profile: Profile, type: UserTypes, team: Int, email: String) {
        self.type = type
        self.team = team
        self.profile = profile
        self.email = email
        
        _checkRep()
    }
    
    convenience init(profile: Profile, type: UserTypes, email: String) {
        self.init(profile: profile, type: type, team: Config.noTeam, email: email)
    }
    
    init?(snapshot: FIRDataSnapshot) {
        guard let snapshotValue = snapshot.value as? [String: AnyObject] else {
            return nil
        }
        guard let userTypes = snapshotValue[Config.userType] as? [String: Bool], let isParticipant = userTypes[Config.isParticipant], let isSpeaker = userTypes[Config.isSpeaker], let isMentor = userTypes[Config.isMentor], let isOrganizer = userTypes[Config.isOrganizer], let isAdmin = userTypes[Config.isAdmin] else {
            return nil
        }
        self.type = UserTypes(isParticipant: isParticipant, isSpeaker: isSpeaker, isMentor: isMentor, isOrganizer: isOrganizer, isAdmin: isAdmin)
        guard let team = snapshotValue[Config.team] as? Int else {
            return nil
        }
        self.team = team
        guard let profileSnapshot = snapshotValue[Config.profile] as? [String: Any], let profile = Profile(snapshotValue: profileSnapshot) else {
            return nil
        }
        self.profile = profile
        guard let email = snapshotValue[Config.email] as? String else {
            return nil
        }
        self.email = email
    }
    
    var hasTeam: Bool {
        return team != Config.noTeam
    }
    
    func setTeamIndex(index: Int) {
        guard type.isParticipant else {
            return
        }
        team = index
    }
    
    func setMentor(mentor: Mentor) {
        guard type.isMentor else {
            return
        }
        self.mentor = mentor
    }
    
    func toDictionary() -> [String: Any] {
        guard let mentor = mentor else {
            return [Config.userType: type.toDictionary(), Config.team: team, Config.email: email, Config.profile: profile.toDictionary(), Config.mentor: ""]
        }
        
        return [Config.userType: type.toDictionary(), Config.team: team, Config.email: email, Config.profile: profile.toDictionary(), Config.mentor: mentor.toDictionary()]
    }
    
    internal func _checkRep() {
        // Assumption: type, profile and team have met their representation invariants.
        assert (Utility.isValidEmail(testStr: email))
        if !type.isParticipant {
            assert(team == -1)
        }
    }
    
}
