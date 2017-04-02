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
    
    var image: UIImage?
    var name : String
    var date_time: Date
    var description: String
    var details: String
    var venue: String
    init(image: UIImage?, name: String, date_time: Date, venue: String, description: String, details: String) {
        self.image = image
        self.name = name
        self.date_time = date_time
        self.venue = venue
        self.description = description
        self.details = details
    }
    
    init?(snapshot: FIRDataSnapshot) {
        guard let snapshotValue = snapshot.value as? [String: AnyObject] else {
            return nil
        }
        
        guard let name = snapshotValue[Config.name] as? String else {
            return nil
        }
        self.name = name
        guard let timestamp = snapshotValue[Config.dateTime] as? TimeInterval else {
            return nil
        }
        self.date_time = Date(timeIntervalSince1970: timestamp)
        guard let desc = snapshotValue[Config.desc] as? String else {
            return nil
        }
        self.description = desc
        guard let details = snapshotValue[Config.details] as? String else {
            return nil
        }
        self.details = details
        guard let venue = snapshotValue[Config.venue] as? String else {
            return nil
        }
        self.venue = venue
    }
    
    public func toAnyObject() -> Any {
        return [
            Config.name: name,
            Config.dateTime: date_time.timeIntervalSince1970,
            Config.desc: description,
            Config.details: details,
            Config.venue: venue
        ]
    }
    
    public func getDayString() -> String {
        return date_time.string(format: Config.dateTimeFormatDayString)
    }
    
}
