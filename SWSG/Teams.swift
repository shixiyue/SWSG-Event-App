//
//  Teams.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/18/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation

class Teams {
    private static var teamsInstance = Teams()
    private var teams : [Team] {
        didSet {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "teams"), object: self)
            print("saving teams")
            Storage.saveTeams(data: teams, fileName: "Teams")
        }
    }
    
    private init() {
        print("reading from storage for teams")
        self.teams = Storage.readTeams(fileName: "Teams") ?? [Team]()
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
    
    public func replaceTeamAt(index: Int, with team: Team) {
        teams[index] = team
    }
    
    public var count: Int {
        get {
            return teams.count
        }
    }
    
}


