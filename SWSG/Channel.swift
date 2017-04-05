//
//  Chat.swift
//  SWSG
//
//  Created by Jeremy Jee on 23/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import Firebase

class Channel {
    var id: String
    var icon: UIImage?
    var name: String
    var latestMessage: Message?
    
    init(id: String, icon: UIImage?, name: String) {
        self.id = id
        self.icon = icon
        self.name = name
    }
    
    init?(id: String, snapshot: FIRDataSnapshot) {
        self.id = id
        
        guard let snapshotValue = snapshot.value as? [String: AnyObject] else {
            return nil
        }
        
        guard let name = snapshotValue[Config.name] as? String else {
            return nil
        }
        self.name = name
    }
    
}
