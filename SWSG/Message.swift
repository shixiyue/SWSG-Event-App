//
//  Message.swift
//  SWSG
//
//  Created by Jeremy Jee on 23/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import Firebase

/**
 Message is a class used to represent a Message in the Chat System
 
 Specifications:
 - senderId: User ID of the Sender
 - senderName: Username of the Sender
 - timestamp: The Date that the message was sent
 - text: The text of the message
 - image: The URL of the image for the message
 
 Representation Invariant:
 - The message should have either text or image, both cannot be null together
 */
struct Message {
    private (set) var senderId: String
    private (set) var senderName: String
    private (set) var timestamp: Date
    private (set) var text: String?
    private (set) var image: String?
    
    init(senderId: String, senderName: String, timestamp: Date, text: String?, image: String?) {
        self.senderId = senderId
        self.senderName = senderName
        self.timestamp = timestamp
        self.text = text
        self.image = image
    }
    
    init?(snapshot: FIRDataSnapshot) {
        guard let snapshotValue = snapshot.value as? [String: AnyObject] else {
            return nil
        }
        
        guard let id = snapshotValue[Config.senderId] as? String else {
            return nil
        }
        self.senderId = id
        
        guard let name = snapshotValue[Config.senderName] as? String else {
            return nil
        }
        self.senderName = name
        
        guard let timestamp = snapshotValue[Config.timestamp] as? String else {
            return nil
        }
        self.timestamp = Utility.fbDateTimeFormatter.date(from: timestamp)!
        
        if let text = snapshotValue[Config.text] as? String {
            self.text = text
        }
        
        if let image = snapshotValue[Config.image] as? String {
            self.image = image
        }
        
    }
    
    fileprivate func checkRep() {
        #if DEBUG
        if text == nil && image == nil {
            assert(false)
        }
        #endif
    }
}
