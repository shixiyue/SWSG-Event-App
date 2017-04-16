//
//  RegistrationEvent.swift
//  SWSG
//
//  Created by Jeremy Jee on 13/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation
import Firebase

/**
 RegistrationEvent is a class that represents a Registration Event in the
 Registration System
 
 Specifications:
 - id: ID of the Registration Event as assigned by Firebase
 - name: Name of the Registration Event
 - registeredUsers: Array of user IDs who have been registered for that event
 */
class RegistrationEvent {
    var id: String?
    var name: String
    var registeredUsers: [String]
    
    init(name: String) {
        self.name = name
        self.registeredUsers = [String]()
    }
    
    init?(id: String, snapshot: FIRDataSnapshot) {
        self.id = id
        
        guard let snapshot = snapshot.value as? [String: Any] else {
            return nil
        }
        
        guard let name = snapshot[Config.name] as? String else {
            return nil
        }
        self.name = name
        
        if let registeredUsers = snapshot[Config.registeredUsers] as? [String] {
            self.registeredUsers = registeredUsers
        } else {
            self.registeredUsers = [String]()
        }
        
    }
    
    func toDictionary() -> [String: Any] {
        return [Config.name: name, Config.registeredUsers: registeredUsers]
    }
}
