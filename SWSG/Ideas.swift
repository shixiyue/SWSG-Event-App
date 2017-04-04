//
//  Ideas.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/23/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation

class Ideas {
    
    var count: Int { return ideas.count }
    
    private static var ideasInstance = Ideas()
    private var ideas : [Idea] {
        didSet {
            //Storage.saveIdeas(data: ideas, fileName: "Ideas")
        }
    }
    
    private init() {
        print("reading from storage for ideas")
        ideas = [Idea]()
       //self.ideas = Storage.readIdeas(fileName: "Ideas") ?? [Idea]()
    }
    
    class func sharedInstance() -> Ideas {
        return ideasInstance
    }
    
    func addIdea(idea: Idea) {
        ideas.append(idea)
    }
    
    func retrieveIdeaAt(index: Int) -> Idea {
        return ideas[index]
    }
    
    func save() {
        //Storage.saveIdeas(data: ideas, fileName: "Ideas")
    }
   
}
