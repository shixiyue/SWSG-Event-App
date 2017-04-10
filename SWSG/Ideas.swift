//
//  Ideas.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/23/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation
import Firebase

class Ideas {
    
    var count: Int { return ideas.count }
    
    private static var ideasInstance = Ideas()
    private var ideas : [Idea]
    
    private init() {
        ideas = []
    }
    
    class func sharedInstance() -> Ideas {
        return ideasInstance
    }
    
    func add(snapshot: FIRDataSnapshot) {
        guard let snapshotValue = snapshot.value as? [String: Any] else {
            return
        }
        guard let idea = Idea(snapshotValue: snapshotValue), ideas.index(of: idea) == nil else {
            return
        }
        ideas.append(idea)
        ideas = ideas.sorted{$0.name.caseInsensitiveCompare($1.name) == .orderedAscending}
    }
    
    func update(snapshot: FIRDataSnapshot) {
        guard let snapshotValue = snapshot.value as? [String: Any] else {
            return
        }
        guard let idea = Idea(snapshotValue: snapshotValue), let index = ideas.index(of: idea) else {
            return
        }
        ideas[index] = idea
        ideas = ideas.sorted{$0.name.caseInsensitiveCompare($1.name) == .orderedAscending}
    }
    
    func remove(snapshot: FIRDataSnapshot) -> Int? {
        guard let snapshotValue = snapshot.value as? [String: Any], let id = snapshotValue[Config.id] as? String else {
            return nil
        }
        for (index, idea) in ideas.enumerated() {
            if let ideaId = idea.id, ideaId == id {
                ideas.remove(at: index)
                return index
            }
        }
        return nil
    }
    
    func retrieveIdeaAt(index: Int) -> Idea {
        return ideas[index]
    }
    
    func getAllIdeas() -> [Idea] {
        return ideas
    }
    
    func removeIdea(idea: Idea) {
        guard let id = idea.id else {
            return
        }
        System.client.removeIdea(for: id)
    }
    
}
