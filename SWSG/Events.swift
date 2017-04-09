//
//  Events.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/16/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class Events {
    private static var eventsInstance = Events()
    private var events = [Date: [Event]]() {
        didSet {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "events"), object: self)
        }
    }
    
    private init() {
        events = [Date.date(from: "2017 04 05"): [Event(image: [UIImage](), name: "Check-In Registration", start_datetime: "", end_datetime:"", venue: "Outside Meeting Room 1", description: "Please register and collect your breakfast outside Meeting Room 1", details: "Kindly get all your members to register Outside Meeting Room 1 to collect your daily pass and Wi-Fi password. \nPlease bring a photo ID for identification, duplicates are not accepted. Each member has to be present at the registration"),
                                                  Event(image: [UIImage](), name: "Morning Keynote", start_datetime:  "2017 04 05", end_datetime: "2017 04 05", venue: "Theatre 3", description: "Mr Saravanan (Google Singapore) will be given a talk on Cloud Computing and Software as a Service", details: "blah blah blah")],
                  Date.date(from: "2017 04 06"): [Event(image: [UIImage](), name: "Morning Keynote", start_datetime: "2017 04 05", end_datetime: "2017 04 06", venue: "Theatre 3", description: "Mr Saravanan (Google Singapore) will be given a talk on Cloud Computing and Software as a Service", details: "blah blah blah"),
                                                  Event(image: [UIImage](), name: "Morning Keynote", start_datetime: "2017 04 06", end_datetime: "2017 04 05", venue: "Theatre 3", description: "Mr Saravanan (Google Singapore) will be given a talk on Cloud Computing and Software as a Service", details: "blah blah blah")]]
    }
    
    class func sharedInstance() -> Events {
        return eventsInstance
    }
    
    public var count: Int {
        get {
            return events.count
        }
    }
    
    public func addEvent(event: Event, to date: Date) {
        if var events = self.events[date] {
            events.append(event)
            self.events.updateValue(events, forKey: date)
        } else {
            self.events.updateValue([event], forKey: date)
        }
    }
    
    public func deleteEventAt(index: Int, from date: Date) {
        if var events = self.events[date] {
            events.remove(at: index)
            self.events.updateValue(events, forKey: date)
        }
    }
    
    public func retrieveEventAt(index: Int, at date: Date) -> Event? {
        guard let events = self.events[date] else {
            return nil
        }
        return events[index]
    }
    
    public func retrieveEvent(at date: Date) -> [Event]? {
        return self.events[date]
    }
    
    public func contains(date: Date) -> Bool {
        for i in self.events.keys {
            if i.string(format: "yyyy MM dd") == date.string(format: "yyyy MM dd") {
                return true
            }
        }
        return false
    }
    
    
}

