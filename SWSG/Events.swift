//
//  Events.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/16/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class Events: Event {
    
    var image: UIImage {
        get {
            return self.image
        }
        set {
            self.image = newValue
        }
    }
    var date_time: Date {
        get {
            return self.date_time
        }
        set {
            self.date_time = newValue
        }
    }
    var venue: String {
        get {
            return self.venue
        }
        set {
            self.venue = newValue
        }
    }
    var description: String {
        get {
            return self.description
        }
        set {
            self.description = newValue
        }
    }
    var details: String {
        get {
            return self.details
        }
        set {
            self.details = newValue
        }
    }
    
    init(image: UIImage, date_time: Date, venue: String, description: String, details: String) {
        self.image = image
        self.date_time = date_time
        self.venue = venue
        self.description = description
        self.details = details
    }

    
}
