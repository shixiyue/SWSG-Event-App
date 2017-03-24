//
//  Chat.swift
//  SWSG
//
//  Created by Jeremy Jee on 23/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

struct Channel {
    var id: String
    var icon: UIImage
    var name: String
    var messages: [Message]
    
    init(id: String, icon: UIImage, name: String) {
        self.id = id
        self.icon = icon
        self.name = name
        self.messages = [Message]()
    }
    
    init(id: String, name: String) {
        self.init(id: id, icon: UIImage(named: "Profile")!, name: name)
    }
    
}
