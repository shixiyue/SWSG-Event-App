//
//  Profile.swift
//  SWSG
//
//  Created by shixiyue on 11/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

/// `Profile` represents the profile of a User.
class Profile: NSObject, NSCoding {
    
    public private (set) var name: String
    public private (set) var image: UIImage
    public private (set) var job: String
    public private (set) var company: String
    public private (set) var country: String
    public private (set) var education: String
    public private (set) var skills: String
    public private (set) var desc: String

    init(name: String, image: UIImage, job: String, company: String, country: String,
         education: String, skills: String, description: String) {
        self.name = name
        self.image = image
        self.job = job
        self.company = company
        self.country = country
        self.education = education
        self.skills = skills
        self.desc = description
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: Config.name) as? String else {
            return nil
        }
        self.name = name
        guard let image = aDecoder.decodeObject(forKey: Config.image) as? UIImage else {
            return nil
        }
        self.image = image
        guard let job = aDecoder.decodeObject(forKey: Config.job) as? String else {
            return nil
        }
        self.job = job
        guard let company = aDecoder.decodeObject(forKey: Config.company) as? String else {
            return nil
        }
        self.company = company
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
        guard let desc = aDecoder.decodeObject(forKey: Config.desc) as? String else {
            return nil
        }
        self.desc = desc
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: Config.name)
        aCoder.encode(image, forKey: Config.image)
        aCoder.encode(job, forKey: Config.job)
        aCoder.encode(company, forKey: Config.company)
        aCoder.encode(country, forKey: Config.country)
        aCoder.encode(education, forKey: Config.education)
        aCoder.encode(skills, forKey: Config.skills)
        aCoder.encode(desc, forKey: Config.desc)
    }
}
