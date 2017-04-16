//
//  MenuItems.swift
//  SWSG
//
//  Created by Jeremy Jee on 14/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

/**
 MenuItems is a Struct used by MenuViewController to display the Images for
 items as well as an enum of MenuOrder to display the different menu options
 */
struct MenuItems {
    static let items = ["Home",
                        "Information",
                        "Schedule",
                        "Mentors",
                        "Teams",
                        "Chat",
                        "Ideas",
                        "People",
                        "Registration",
                        "Logout"]
    
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
        case people = 7
        case registration = 8
        case logout = 9
    }

}
