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
    
    var teams = [Team]()
    var count: Int {
        get {
            return teams.count
        }
    }
    
    func replaceTeams(teams: [Team]) {
        self.teams = teams
    }
    
    func addTeam(team: Team) {
        if let index = teams.index(of: team) {
            teams[index] = team
        } else {
            teams.append(team)
        }
    }
    
    func retrieveTeamWith(id: String, completion: @escaping (Team?) -> Void) {
        System.client.getTeam(with: id, completion: {
            (team, error) in
            completion(team)
        })
    }
    
    func retrieveTeamWith(index: Int) -> Team? {
        if index < teams.count {
            return teams[index]
        } else {
            return nil
        }
    }
    
    func replaceTeamAt(index: Int, with team: Team) {
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
}


