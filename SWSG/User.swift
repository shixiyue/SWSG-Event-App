//
//  User.swift
//  SWSG
//
//  Created by shixiyue on 11/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation

/// `User` represents a User of SWSG App.
class User: NSObject, NSCoding {
    
    let email: String
    public private (set) var profile: Profile
    public internal (set) var password: String
    
    init(profile: Profile, password: String, email: String) {
        self.profile = profile
        self.password = password
        self.email = email
        
        super.init()
        _checkRep()
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let profile = aDecoder.decodeObject(forKey: Config.profile) as? Profile else {
            return nil
        }
        self.profile = profile
        guard let password = aDecoder.decodeObject(forKey: Config.password) as? String else {
            return nil
        }
        self.password = password
        guard let email = aDecoder.decodeObject(forKey: Config.email) as? String else {
            return nil
        }
        self.email = email
        
        super.init()
        _checkRep()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(profile, forKey: Config.profile)
        aCoder.encode(password, forKey: Config.password)
        aCoder.encode(email, forKey: Config.email)
    }
    
    func setPassword(newPassword: String) -> Bool {
        _checkRep()
        password = newPassword
        _checkRep()
        // Cominucate with backend...
        return true
    }
    
    func toDictionary() -> [String: Any] {
        return [Config.email: email, Config.password: password, Config.profile: profile.toDictionary()]
    }
    
    internal func _checkRep() {
        // Assumption: type, profile and team have met their representation invariants.
        assert (Utility.isValidEmail(testStr: email) && Utility.isValidPassword(testStr: password))
    }
    
}
