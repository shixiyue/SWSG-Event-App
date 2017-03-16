//
//  Events.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/16/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

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

    
}
