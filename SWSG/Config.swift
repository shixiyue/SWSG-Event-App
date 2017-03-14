//
//  Config.swift
//  SWSG
//
//  Created by shixiyue on 13/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

struct Config {
    
    static let defaultCountry = "Singapore"
    
    // Keys for encode/decode:
    static let user = "user"
    static let profile = "profile"
    static let email = "email"
    static let password = "password"
    static let team = "team"
    static let name = "name"
    static let job = "job"
    static let country = "country"
    static let education = "education"
    static let skills = "skills"
    static let isParticipant = "isParticipant"
    static let isSpeaker = "isSpeaker"
    static let isMentor = "isMentor"
    static let isOrganizer = "isOrganizer"
    static let isAdmin = "isAdmin"
    
    // Parameters for UI:
    static let defaultButtonFont = UIFont(name: "Futura", size: 20)
    static let buttonCornerRadius: CGFloat = 5
    static let themeColor = UIColor(red: 232.0/255.0, green: 43.0/255.0, blue: 49.0/255.0, alpha: CGFloat(1))
    static let disableAlpha: CGFloat = 0.5
    static let enableAlpha: CGFloat = 1
    
    // Parameters for Storyboard:
    static let logInSignUp = "LoginSignup"
    static let initialScreen = "InitialScreen"
    static let signUpTable = "signUpTable"
    static let main = "Main"
    static let mainMenuScreen = "NavigationController"
    
    // Parameters for information message:
    static let done = "Done"
    
    static let passwordMinLength = 6
}
