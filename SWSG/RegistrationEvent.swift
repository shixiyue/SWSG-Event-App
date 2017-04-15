//
//  RegistrationEvent.swift
//  SWSG
//
//  Created by Jeremy Jee on 13/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation
import Firebase

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
            print("test2")
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
    
    func registerUser(uid: String) {
        registeredUsers.append(uid)
    }
    
    func toDictionary() -> [String: Any] {
        return [Config.name: name, Config.registeredUsers: registeredUsers]
    }
}
