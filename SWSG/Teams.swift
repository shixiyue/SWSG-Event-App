//
//  Teams.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/18/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation

class Teams {
    private static var teamsInstance = Teams(teams: [Team]())
    private var teams : [Team] {
        didSet {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "teams"), object: self)
        }
    }
    
    private init(teams: [Team]) {
        self.teams = teams
    }
    
    class func sharedInstance() -> Teams {
        return teamsInstance
    }
    
    public func addTeam(team: Team) {
        teams.append(team)
    }
    
    public func retrieveTeamAt(index: Int) -> Team {
        return teams[index]
    }
    public var count: Int {
        get {
            return teams.count
        }
    }
}
