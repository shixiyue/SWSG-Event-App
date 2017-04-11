//
//  Faq.swift
//  SWSG
//
//  Created by Shi Xiyue on 11/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation

class Faq {
    
    var question: String
    var answer: String
    
    init(question: String, answer: String) {
        self.question = question
        self.answer = answer
    }
    
    func toDictionary() -> [String: String] {
        return [Config.question: question, Config.answer: answer]
    }
    
}
