//
//  ProfileItems.swift
//  SWSG
//
//  Created by shixiyue on 17/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation

struct ProfileItems {
    
    private enum Fields: String {
        case country = "Country"
        case job = "Job"
        case company = "Company"
        case education = "Education"
        case skills = "Skills"
        case description = "Description"
    }
    
    static func getItems(user: User?) -> [(String, String)] {
        guard let user = user else {
            let defaultContent = Config.defaultContent
            return [(Fields.country.rawValue, defaultContent), (Fields.job.rawValue, defaultContent), (Fields.company.rawValue, defaultContent), (Fields.education.rawValue, defaultContent), (Fields.skills.rawValue, defaultContent), (Fields.description.rawValue, defaultContent)]
        }
        return [(Fields.country.rawValue, user.profile.country), (Fields.job.rawValue, user.profile.job), (Fields.company.rawValue, user.profile.company), (Fields.education.rawValue, user.profile.education), (Fields.skills.rawValue, user.profile.skills), (Fields.description.rawValue, user.profile.desc)]
    }
    
}
