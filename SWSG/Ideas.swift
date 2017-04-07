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
            
        }
    }
    
    private init() {
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
    
    func removeIdea(idea: Idea) {
        guard let index = ideas.index(of: idea) else {
            return
        }
        ideas.remove(at: index)
    }
    
    func updateIdea(_ idea: Idea, name: String, description: String, mainImage: UIImage, images: [UIImage], videoLink: String) {
        guard let index = ideas.index(of: idea) else {
            return
        }
        ideas[index].update(name: name, description: description, mainImage: mainImage, images: images, videoLink: videoLink)
    }
   
}
