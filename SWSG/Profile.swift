//
//  Profile.swift
//  SWSG
//
//  Created by shixiyue on 11/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import Firebase

/// `Profile` represents the profile of a User.
class Profile: NSObject, NSCoding {
    
    public private (set) var type: UserTypes
    public private (set) var team = Config.noTeam
    public private (set) var name: String
    public private (set) var username: String
    public private (set) var image: UIImage
    public private (set) var job: String
    public private (set) var company: String
    public private (set) var country: String
    public private (set) var education: String
    public private (set) var skills: String
    public private (set) var desc: String

    init(type: UserTypes, team: Int, name: String, username: String, image: UIImage, job: String, company: String, country: String,
         education: String, skills: String, description: String) {
        self.type = type
        self.team = team
        self.name = name
        self.username = username
        self.image = image
        self.job = job
        self.company = company
        self.country = country
        self.education = education
        self.skills = skills
        self.desc = description
        
        super.init()
        _checkRep()
    }
    
    init?(snapshot: FIRDataSnapshot) {
        guard let snapshotValue = snapshot.value as? [String: AnyObject] else {
            return nil
        }
        guard let userTypes = snapshotValue[Config.userType] as? [String: Bool], let isParticipant = userTypes[Config.isParticipant], let isSpeaker = userTypes[Config.isSpeaker], let isMentor = userTypes[Config.isMentor], let isOrganizer = userTypes[Config.isOrganizer], let isAdmin = userTypes[Config.isAdmin] else {
            return nil
        }
        self.type = UserTypes(isParticipant: isParticipant, isSpeaker: isSpeaker, isMentor: isMentor, isOrganizer: isOrganizer, isAdmin: isAdmin)
        guard let team = snapshotValue[Config.team] as? Int else {
            return nil
        }
        self.team = team
        guard let name = snapshotValue[Config.name] as? String else {
            return nil
        }
        self.name = name
        guard let username = snapshotValue[Config.username] as? String else {
            return nil
        }
        self.username = username
        image = UIImage()
        guard let job = snapshotValue[Config.job] as? String else {
            return nil
        }
        self.job = job
        guard let company = snapshotValue[Config.company] as? String else {
            return nil
        }
        self.company = company
        guard let country = snapshotValue[Config.country] as? String else {
            return nil
        }
        self.country = country
        guard let education = snapshotValue[Config.education] as? String else {
            return nil
        }
        self.education = education
        guard let skills = snapshotValue[Config.skills] as? String else {
            return nil
        }
        self.skills = skills
        guard let desc = snapshotValue[Config.desc] as? String else {
            return nil
        }
        self.desc = desc
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.type = aDecoder.decodeUserTyes()
        self.team = aDecoder.decodeInteger(forKey: Config.team)
        guard let name = aDecoder.decodeObject(forKey: Config.name) as? String else {
            return nil
        }
        self.name = name
        guard let username = aDecoder.decodeObject(forKey: Config.username) as? String else {
            return nil
        }
        self.username = username
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
        
        super.init()
        _checkRep()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encodeUserTypes(type)
        aCoder.encode(team, forKey: Config.team)
        aCoder.encode(name, forKey: Config.name)
        aCoder.encode(username, forKey: Config.username)
        aCoder.encode(image, forKey: Config.image)
        aCoder.encode(job, forKey: Config.job)
        aCoder.encode(company, forKey: Config.company)
        aCoder.encode(country, forKey: Config.country)
        aCoder.encode(education, forKey: Config.education)
        aCoder.encode(skills, forKey: Config.skills)
        aCoder.encode(desc, forKey: Config.desc)
    }
    
    func updateProfile(name: String, username: String, image: UIImage, job: String, company: String, country: String,
                       education: String, skills: String, description: String) {
        _checkRep()
        
        self.name = name
        self.username = username
        self.image = image
        self.job = job
        self.company = company
        self.country = country
        self.education = education
        self.skills = skills
        self.desc = description
        
        _checkRep()
    }
    
    func updateImage(image: UIImage) {
        _checkRep()
        self.image = image
        _checkRep()
    }
    
    func setTeamIndex(index: Int) {
        guard type.isParticipant else {
            return
        }
        team = index
    }
    
    func toDictionary() -> [String: Any] {
        return [Config.userType: type.toDictionary(), Config.team: team, Config.name: name, Config.username: username, Config.country: country, Config.job: job, Config.company: company, Config.education: education, Config.skills: skills, Config.desc: desc]
    }
    
    private func _checkRep() {
        assert(!(name.isEmpty || username.isEmpty || country.isEmpty || job.isEmpty || company.isEmpty || education.isEmpty || skills.isEmpty || desc.isEmpty) /*&& image.cgImage != nil*/)
        if !type.isParticipant {
            assert(team == -1)
        }
    }
}
