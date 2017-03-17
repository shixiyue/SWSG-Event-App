//
//  ProfileItems.swift
//  SWSG
//
//  Created by shixiyue on 17/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation

struct ProfileItems {
    
    static var items: [(String, String)] {
        get {
            guard let user = System.activeUser else {
                return [("Country", ""), ("Job", ""), ("Company", ""), ("Education", ""), ("Skills", ""), ("Description", "")]
            }
            return [("Country", user.profile.country), ("Job", user.profile.job), ("Company", user.profile.company), ("Education", user.profile.education), ("Skills", user.profile.skills), ("Description", user.profile.desc)]
        }
    }
    
    static let count = items.count
    
}
