//
//  Team.swift
//  SWSG
//
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation
import Firebase

/**
    Team represents a team within the Team system
 
    Specifications:
        - members: A String Array of the UIDs of Members
        - name: The Name of the Team
        - lookingFor: The type of people the team is looking for
        - isPrivate: Whether the team is a private team
        - id: ID of the Team as assigned by Firebase
        - tags: String Array of Tags of the existing Skill Set of the Team
 */
class Team {
    typealias uid = String
    
    public private (set) var members: [uid]
    public private (set) var name: String
    public private (set) var lookingFor: String?
    public private (set) var isPrivate: Bool
    var id: String?
    public private (set) var tags: [String]? {
        didSet {
             NotificationCenter.default.post(name: Notification.Name(rawValue: "tags"), object: self)
        }
    }
    
    init(id: String?, members: [uid], name: String, lookingFor: String?, isPrivate: Bool, tags: [String]?) {
        self.id = id
        self.members = members
        self.name = name
        self.lookingFor = lookingFor
        self.isPrivate = isPrivate
        self.tags = tags
        checkRep()
    }
    
    init?(id: String, snapshot: FIRDataSnapshot) {
        guard let snapshotValue = snapshot.value as? [String: Any] else {
            return nil
        }
        self.id = id
        guard let name = snapshotValue["teamName"] as? String else {
            return nil
        }
        self.name = name
        guard let members = snapshotValue["members"] as? [uid] else {
            return nil
        }
        self.members = members
        guard let lookingFor = snapshotValue["lookingFor"] as? String else {
            return nil
        }
        self.lookingFor = lookingFor
        guard let isPrivate = snapshotValue["isPrivate"] as? Bool else {
            return nil
        }
        self.isPrivate = isPrivate
        if let tags = snapshotValue["tags"] as? [String] {
            self.tags = tags
        } else {
            self.tags = []
        }
        checkRep()
    }
    
    func addMember(member: User) {
        guard let uid = member.uid else {
            return
        }
        members.append(uid)
        checkRep()
    }
    
    func removeMember(member: User) {
        guard let uid = member.uid else {
            return
        }
        if containsMember(member: member) {
            members.remove(at: members.index(where: {$0 == uid})!)
        }
    }
    
    func containsMember(member: User) -> Bool {
        guard let uid = member.uid else {
            return false
        }
        return members.contains(where: {$0 == uid})
    }
    
    func setId(id: String) {
        self.id = id
        checkRep()
    }
    
    private func checkRep() {
        #if DEBUG
        assert(members.count != 0 && !name.isEmpty && lookingFor != nil && !lookingFor!.isEmpty && tags != nil && tags!.count != 0)
        #endif
    }
}

extension Team {
    func toDictionary() -> [String: Any] {
        var data = [String: Any]()
        if let id = id {
            data.updateValue(id, forKey: "id")
        }
        data.updateValue(members, forKey: "members")
        data.updateValue(name, forKey: "teamName")
        data.updateValue(tags ?? [String](), forKey: "tags")
        data.updateValue(lookingFor ?? "", forKey: "lookingFor")
        data.updateValue(isPrivate, forKey: "isPrivate")
        return data
    }
}

extension Team: Equatable { }

func ==(lhs: Team, rhs: Team) -> Bool {
    
    if let lhsId = lhs.id, let rhsId = rhs.id {
        return lhsId == rhsId
    }
    return false
}
