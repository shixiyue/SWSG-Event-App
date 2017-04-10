//
//  Events.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/16/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class Events {
    public static var instance = Events()
    private var events = [Date: [Event]]()
    
    private init() {
        System.client.getEvents(completion: { (events, error) in
            self.events = events
        })
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

