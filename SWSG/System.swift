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
    
}
