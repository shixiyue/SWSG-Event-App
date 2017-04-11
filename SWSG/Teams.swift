//
//  Teams.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/18/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation
import Firebase

class Teams {
    private static var teamsInstance = Teams()
    private var teams : [Team] {
        didSet {
          //  NotificationCenter.default.post(name: Notification.Name(rawValue: "teams"), object: self)
            //Storage.saveTeams(data: teams, fileName: "Teams")
        }
    }
    
    private init() {
        teams = [Team]()
        
    }
    
    class func sharedInstance() -> Teams {
        return teamsInstance
    }
    
    public func replaceTeams(teams: [Team]) {
         self.teams = teams
    }
    
    public func addTeam(team: Team) {
        teams.append(team)
    }
    
    public func retrieveTeamAt(index: Int) -> Team {
        //return Team(members: [], name: "", lookingFor: nil, isPrivate: false, tags: nil)
        return teams[index]
    }
    
    public func replaceTeamAt(index: Int, with team: Team) {
        teams[index] = team
    }
    
    public var count: Int {
        get {
            return teams.count
        }
    }
    
}


