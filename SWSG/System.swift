//
//  System.swift
//  SWSG
//
//  Created by Jeremy Jee on 16/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

struct System {
    
    public static var activeUser: Participant {
        let image = UIImage(named: "trump")
        let profile = Profile(name: "Mr Tan Hwee Huat", image: image!, job: "Asset Manager",
                              company: "UOB Pte. Ltd.", country: "Singapore",
                              education: "National University of Singapore",
                              skills: "Financial Planning", description: "Awesome guy")
        let participant = Participant(profile: profile, password: "", email: "", team: nil)
        
        return participant
    }
    
    public static var mentors: [Mentor] {
        var mentors = [Mentor]()
        let image = UIImage(named: "Profile")
        let profile = Profile(name: "Mr Tan Hwee Huat", image: image!, job: "Asset Manager",
                              company: "UOB Pte. Ltd.", country: "Singapore",
                              education: "National University of Singapore",
                              skills: "Financial Planning", description: "Awesome guy")
        
        for _ in 0...4 {
            let mentor = Mentor(profile: profile, field: .business)
            mentor.addSlots(on: Date.date(from: "2017-07-21"))
            mentor.addSlots(on: Date.date(from: "2017-07-22"))
            mentor.addSlots(on: Date.date(from: "2017-07-23"))
            mentors.append(mentor)
        }
        
        return mentors
    }
}
