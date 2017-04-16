//
//  Comment.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/17/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation
import Firebase

/**
 Comment is a class used to represent a Comment in an Event
 
 Specifications:
 - authorID: User ID of the User who posted the comment
 - timestamp: Date that the timestamp was posted
 - text: Contents of the Comment
 */
class Comment {
    
    var authorID: String
    var timestamp: Date
    var text: String
    
    init(authorID: String, timestamp: Date, text: String) {
        self.authorID = authorID
        self.timestamp = timestamp
        self.text = text
    }
    
    convenience init(authorID: String, text: String) {
        self.init(authorID: authorID, timestamp: Date.init(), text: text)
    }
    
    init?(snapshot: [String: String]) {
        guard let id = snapshot[Config.id] else {
            return nil
        }
        self.authorID = id
        
        guard let timestampString = snapshot[Config.timestamp],
            let timestamp = Utility.fbDateTimeFormatter.date(from: timestampString) else {
                return nil
        }
        self.timestamp = timestamp
        
        guard let text = snapshot[Config.text] else {
            return nil
        }
        self.text = text
    }
    
    
    func toDictionary() -> [String: String] {
        return [Config.id: authorID,
                Config.timestamp: Utility.fbDateTimeFormatter.string(from: timestamp),
                Config.text: text]
    }
}
