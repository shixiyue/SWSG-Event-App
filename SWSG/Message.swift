//
//  Message.swift
//  SWSG
//
//  Created by Jeremy Jee on 23/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import Firebase

struct Message {
    var senderId: String
    var senderName: String
    var timestamp: Date
    var text: String?
    var image: String?
    
    init(senderId: String, senderName: String, timestamp: Date, text: String?, image: String?) {
        self.senderId = senderId
        self.senderName = senderName
        self.timestamp = timestamp
        self.text = text
        self.image = image
    }
    
    init?(snapshot: FIRDataSnapshot) {
        guard let snapshotValue = snapshot.value as? [String: AnyObject] else {
            print("test2")
            return nil
        }
        
        guard let id = snapshotValue[Config.senderId] as? String else {
            print("test3")
            return nil
        }
        self.senderId = id
        
        guard let name = snapshotValue[Config.senderName] as? String else {
            print("test4")
            return nil
        }
        self.senderName = name
        
        guard let timestamp = snapshotValue[Config.timestamp] as? String else {
            print("test5")
            return nil
        }
        self.timestamp = Utility.fbDateTimeFormatter.date(from: timestamp)!
        
        if let text = snapshotValue[Config.text] as? String {
            print("test6")
            self.text = text
        }
        
        if let image = snapshotValue[Config.image] as? String {
            self.image = image
        }
        
    }
}
