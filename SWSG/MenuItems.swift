//
//  MenuItems.swift
//  SWSG
//
//  Created by Jeremy Jee on 14/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

struct MenuItems {
    static let items = ["Home", "Information", "Schedule", "Mentors", "Teams", "Chat", "Ideas", "Logout"]
    
    static var count: Int {
        return items.count
    }
    
    enum MenuOrder: Int {
        case home = 0
        case information = 1
        case schedule = 2
        case mentors = 3
        case teams = 4
        case chat = 5
        case ideas = 6
        case logout = 7
    }

}
