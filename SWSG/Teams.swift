//
//  Teams.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/18/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation

class Teams {
    public static var teams = [Team]() {
        didSet {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "teams"), object: self)
        }
    }
}
