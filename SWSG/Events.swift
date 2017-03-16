//
//  Events.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/16/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class Events {
    
    var events = [Event(image: nil, name: "Check-In Registration", date_time: Date(), venue: "Outside Meeting Room 1", description: "Please register and collect your breakfast outside Meeting Room 1", details: "Kindly get all your members to register Outside Meeting Room 1 to collect your daily pass and Wi-Fi password. \nPlease bring a photo ID for identification, duplicates are not accepted. Each member has to be present at the registration"),
                  Event(image: nil, name: "Morning Keynote", date_time: Date(), venue: "Theatre 3", description: "Mr Saravanan (Google Singapore) will be given a talk on Cloud Computing and Software as a Service", details: "blah blah blah")]
    var count: Int {
        get {
            return events.count
        }
    }
    
    public func addEvent(event: Event) {
        events.append(event)
    }
    
    public func deleteEventAt(index: Int) {
        events.remove(at: index)
    }
    
    public func retrieveEventAt(index: Int) -> Event? {
        return events[index]
    }
    
    
}

