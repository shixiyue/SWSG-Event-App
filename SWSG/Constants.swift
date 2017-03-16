//
//  Constants.swift
//  SWSG
//
//  Created by Jeremy Jee on 14/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation

struct Constants {
    static var consultationStartTime: Date {
        return Date.time(from: "11:00")
    }
    
    static var consultationEndTime: Date {
        return Date.time(from: "17:00")
    }
    
    static var duration = 60
}

extension Date {
    static func date(from dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = formatter.date(from: dateString) else {
            return Date()
        }
        
        return date
    }
    
    static func time(from timeString: String) -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "HH:mm"
        
        guard let date = formatter.date(from: timeString) else {
            return Date()
        }
        
        return date
    }
    
    static func dateTime(forDate date: Date, forTime time: Date) -> Date {
        let calendar = Calendar.current
        
        var slotComponents = DateComponents()
        slotComponents.day = calendar.component(.day, from: date)
        slotComponents.month = calendar.component(.month, from: date)
        slotComponents.year = calendar.component(.year, from: date)
        slotComponents.hour = calendar.component(.hour, from: time)
        slotComponents.minute = calendar.component(.minute, from: time)
        
        guard let dateTime = calendar.date(from: slotComponents) else {
            return Date()
        }

        return dateTime
    }
    
    func add(minutes: Int) -> Date {
        let calendar = Calendar.current
        guard let newDate = calendar.date(byAdding: .minute, value: minutes, to: self) else {
            return Date()
        }
        
        return newDate
    }
    
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
}
