//
//  Profile.swift
//  SWSG
//
//  Created by shixiyue on 11/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation

/// `Profile` represents the profile of a User.
class Profile: NSObject, NSCoding {
    
    public private (set) var name: String
    public private (set) var job: String
    public private (set) var country: String
    public private (set) var education: String
    public private (set) var skills: String

    init(name: String, job: String, country: String, education: String, skills: String) {
        self.name = name
        self.job = job
        self.country = country
        self.education = education
        self.skills = skills
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: Config.name) as? String else {
            return nil
        }
        self.name = name
        guard let job = aDecoder.decodeObject(forKey: Config.job) as? String else {
            return nil
        }
        self.job = job
        guard let country = aDecoder.decodeObject(forKey: Config.country) as? String else {
            return nil
        }
        self.country = country
        guard let education = aDecoder.decodeObject(forKey: Config.education) as? String else {
            return nil
        }
        self.education = education
        guard let skills = aDecoder.decodeObject(forKey: Config.skills) as? String else {
            return nil
        }
        self.skills = skills
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: Config.name)
        aCoder.encode(job, forKey: Config.job)
        aCoder.encode(country, forKey: Config.country)
        aCoder.encode(education, forKey: Config.education)
        aCoder.encode(skills, forKey: Config.skills)
    }
    
}
