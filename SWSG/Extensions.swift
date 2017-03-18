//
//  Extensions.swift
//  SWSG
//
//  Created by shixiyue on 13/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension NSCoder {
    func encodeUserTypes(_ type: UserTypes) {
        self.encode(type.isParticipant, forKey: Config.isParticipant)
        self.encode(type.isSpeaker, forKey: Config.isSpeaker)
        self.encode(type.isMentor, forKey: Config.isMentor)
        self.encode(type.isOrganizer, forKey: Config.isOrganizer)
        self.encode(type.isAdmin, forKey: Config.isAdmin)
    }
    
    func decodeUserTyes() -> UserTypes {
        let isParticipant = self.decodeBool(forKey: Config.isParticipant)
        let isSpeaker = self.decodeBool(forKey: Config.isSpeaker)
        let isMentor = self.decodeBool(forKey: Config.isMentor)
        let isOrganizer = self.decodeBool(forKey: Config.isOrganizer)
        let isAdmin = self.decodeBool(forKey: Config.isAdmin)
        return UserTypes(isParticipant: isParticipant, isSpeaker: isSpeaker, isMentor: isMentor, isOrganizer: isOrganizer, isAdmin: isAdmin)
    }
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

extension String {
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func trimTrailingWhiteSpace() -> String {
        return self.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
    }
    
    func containsWhiteSpace() -> Bool {
        let range = self.rangeOfCharacter(from: .whitespacesAndNewlines)
        if let _ = range {
            return true
        } else {
            return false
        }
    }
    
}
