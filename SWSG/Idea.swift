//
//  Idea.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/23/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation

class Idea {
    
    public private (set) var name: String
    public private (set) var description: String
    public private (set) var team: String
    
    init(name: String, description: String, team: String) {
        self.name = name
        self.description = description
        self.team = team
    }
    func toDictionary() -> [String: String] {
        return ["ideaName": self.name, "ideaDescription": self.description, "ideaTeam": self.team]
    }
    
}
