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
    private var teams : [Team]
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
    
    public func retrieveTeamWith(id: String) -> Team? {
        //return Team(members: [], name: "", lookingFor: nil, isPrivate: false, tags: nil)
        var teamRetrieved: Team?
        print("id is \(id)")
        System.client.getTeam(with: id, completion: {
            (team, error) in
            print("team is \(team)")
            teamRetrieved = team
        })
        print("team retrieved is \(teamRetrieved)")
        return teamRetrieved
    }
    
    public func retrieveTeamWith(index: Int) -> Team? {
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


