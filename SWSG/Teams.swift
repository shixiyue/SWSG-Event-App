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
   // private static var teamsInstance = Teams()
    var teams = [Team]()
   // private init() {
     //   teams = [Team]()
    //}
    
    //class func sharedInstance() -> Teams {
      //  return teamsInstance
    //}
    
    public func replaceTeams(teams: [Team]) {
         self.teams = teams
    }
    
    public func addTeam(team: Team) {
        teams.append(team)
    }
    
    public func retrieveTeamWith(id: String, completion: @escaping (Team?) -> Void) {
        //return Team(members: [], name: "", lookingFor: nil, isPrivate: false, tags: nil)
        print("id is \(id)")
        System.client.getTeam(with: id, completion: {
            (team, error) in
            completion(team)
        })
    }
    
    public func retrieveTeamWith(index: Int) -> Team? {
        return teams[index]
    }
    
    public func replaceTeamAt(index: Int, with team: Team) {
        teams[index] = team
    }
    
    func replaceTeam(for team: Team) {
        guard let index = teams.index(of: team) else {
            return
        }
        teams[index] = team
    }
    
    func removeTeam(team: Team) {
        guard let index = teams.index(of: team) else {
            return
        }
        teams.remove(at: index)
    }
    
    public var count: Int {
        get {
            return teams.count
        }
    }
    
}


