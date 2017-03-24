//
//  Message.swift
//  SWSG
//
//  Created by Jeremy Jee on 23/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

struct Message {
    var sender: User
    var timestamp: Date
    var message: String
    var image: UIImage?
    
    init(sender: User, timestamp: Date, message: String, image: UIImage?) {
        self.sender = sender
        self.timestamp = timestamp
        self.message = message
        self.image = image
    }
    
    init(sender: User, timestamp: Date, message: String) {
        self.init(sender: sender, timestamp: timestamp, message: message, image: nil)
    }
}
