//
//  Message.swift
//  SWSG
//
//  Created by Jeremy Jee on 23/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

struct Message {
    var senderId: String
    var senderName: String
    var timestamp: Date?
    var text: String?
    var photoURL: String?
    
    init(senderId: String, senderName: String, timestamp: Date?, text: String?, photoURL: String?) {
        self.senderId = senderId
        self.senderName = senderName
        self.timestamp = timestamp
        self.text = text
        self.photoURL = photoURL
    }
}
