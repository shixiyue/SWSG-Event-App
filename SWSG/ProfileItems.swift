//
//  ProfileItems.swift
//  SWSG
//
//  Created by shixiyue on 17/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation

struct ProfileItems {
    
    private enum fields: String {
        case country = "Country"
        case job = "Job"
        case company = "Company"
        case education = "Education"
        case skills = "Skills"
        case description = "Description"
    }
    
    private static let defaultContent = " "
    
    static var items: [(String, String)] {
        get {
            guard let user = System.activeUser else {
                return [(fields.country.rawValue, defaultContent), (fields.job.rawValue, defaultContent), (fields.company.rawValue, defaultContent), (fields.education.rawValue, defaultContent), (fields.skills.rawValue, defaultContent), (fields.description.rawValue, defaultContent)]
            }
            return [(fields.country.rawValue, user.profile.country), (fields.job.rawValue, user.profile.job), (fields.company.rawValue, user.profile.company), (fields.education.rawValue, user.profile.education), (fields.skills.rawValue, user.profile.skills), (fields.description.rawValue, user.profile.desc)]
        }
    }
    
    static let count = items.count
    
}
