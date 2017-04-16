//
//  Faq.swift
//  SWSG
//
//  Created by Shi Xiyue on 11/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

/**
 Faq is a class that represents a faq in the Information System
 
 Specifications:
 - id: The ID of the Faq as given by Firebase
 - question: The question of the faq
 - answer: The answer of the faq
 - Link: The link of the faq
 
 Representation Invariant:
 - The question and answer of the faq cannot be empty
 */
class Faq {
    
    var id: String?
    var question: String
    var answer: String
    var link: String?
    
    init(question: String, answer: String, link: String? = nil) {
        self.question = question
        self.answer = answer
        self.link = link
        _checkRep()
    }
    
    init?(snapshotValue: [String: String]) {
        guard let id = snapshotValue[Config.id] else {
            return nil
        }
        self.id = id
        guard let question = snapshotValue[Config.question] else {
            return nil
        }
        self.question = question
        guard let answer = snapshotValue[Config.answer] else {
            return nil
        }
        self.answer = answer
        self.link = snapshotValue[Config.link]
        _checkRep()
    }
    
    func toDictionary() -> [String: String] {
        var dict = [Config.question: question, Config.answer: answer]
        if let id = id {
            dict[Config.id] = id
        }
        if let link = link {
            dict[Config.link] = link
        }
        return dict
    }
    
    private func _checkRep() {
        #if DEBUG
        assert(!question.isEmpty && !answer.isEmpty)
        #endif
    }
    
}
