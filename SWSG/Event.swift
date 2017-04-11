//
//  Events.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/16/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import Firebase

class Event {
    
    var id: String?
    var image: UIImage?
    var name : String
    var startDateTime: Date
    var endDateTime: Date
    var shortDesc: String
    var description: String
    var venue: String
    var comments: [Comment]
    
    fileprivate let formatter = Utility.fbDateTimeFormatter
    
    init(id: String?, image: UIImage?, name: String, startDateTime: Date, endDateTime: Date, venue: String, shortDesc: String, description: String, comments: [Comment]) {
        self.id = id
        self.image = image
        self.name = name
        self.startDateTime = startDateTime
        self.endDateTime = endDateTime
        self.venue = venue
        self.description = description
        self.shortDesc = shortDesc
        self.comments = comments
    }
    
    init?(id: String, snapshot: FIRDataSnapshot) {
        guard let snapshotValue = snapshot.value as? [String: AnyObject] else {
            return nil
        }
        self.id = id
        guard let name = snapshotValue[Config.name] as? String else {
            return nil
        }
        self.name = name
        guard let startDateTimeString = snapshotValue[Config.startDateTime] as? String,
            let startDateTime = formatter.date(from: startDateTimeString) else {
            return nil
        }
        self.startDateTime = startDateTime
        guard let endDateTimeString = snapshotValue[Config.endDateTime] as? String,
            let endDateTime = formatter.date(from: endDateTimeString) else {
                return nil
        }
        self.endDateTime = endDateTime
        guard let desc = snapshotValue[Config.desc] as? String else {
            return nil
        }
        self.description = desc
        guard let shortDesc = snapshotValue[Config.shortDesc] as? String else {
            return nil
        }
        self.shortDesc = shortDesc
        guard let venue = snapshotValue[Config.venue] as? String else {
            return nil
        }
        self.venue = venue
        
        var comments = [Comment]()
        if let commentsSnapshot = snapshotValue[Config.comments] as? [[String: String]] {
            print("test2\(commentsSnapshot)")
            for commentSnapshot in commentsSnapshot {
                print("test\(commentSnapshot)")
                if let comment = Comment(snapshot: commentSnapshot) {
                    comments.append(comment)
                }
            }
            
            comments = comments.sorted(by: { $0.timestamp < $1.timestamp })
        }
        self.comments = comments
    }
    
    public func toDictionary() -> [String: Any] {
        var dict = [[String: String]]()
        
        for comment in comments {
            dict.append(comment.toDictionary())
        }
        
        return [Config.name: name,
                Config.startDateTime: formatter.string(from: startDateTime),
                Config.endDateTime: formatter.string(from: endDateTime),
                Config.shortDesc: shortDesc,
                Config.desc: description,
                Config.venue: venue,
                Config.comments: dict]
    }
    
}
