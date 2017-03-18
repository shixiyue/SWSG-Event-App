//
//  Storage.swift
//  SWSG
//
//  Created by shixiyue on 13/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

/// `Storage` represents the storage of SWSG App. It will comunicate with the backend.
struct Storage {
    
    /// Saves user data to a json file with the given filename.
    static func saveUser(data: [String: Any], fileName: String) -> Bool {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions())
            try jsonData.write(to: getFileURL(fileName: fileName))
            return true
        } catch _ {
            return false
        }
    }
    
    // TODO: Support different user types
    // TODO: Support user with team <- Add encoding for team
    /// Reads User from json file.
    static func readUser(email: String) -> User? {
        guard let jsonData = try? Data(contentsOf: getFileURL(fileName: email)) else {
            return nil
        }
        guard let data = try? JSONSerialization.jsonObject(with: jsonData as Data, options: .allowFragments), let userInfo = data as? [String: Any] else {
            return nil
        }
        guard let profile = userInfo[Config.profile] as? [String: String], let name = profile[Config.name], let country = profile[Config.country], let job = profile[Config.job], let company = profile[Config.company], let education = profile[Config.education], let skills = profile[Config.skills], let desc = profile[Config.desc] else {
            return nil
        }
        //TODO: Settle image
        let image = UIImage(named: "Profile")!
        let userProfile = Profile(name: name, image: image, job: job, company: company, country: country, education: education, skills: skills, description: desc)
        guard let email = userInfo[Config.email] as? String, let password = userInfo[Config.password] as? String else {
            return nil
        }
        return Participant(profile: userProfile, password: password, email: email, team: nil)
    }
    
    /// Gets the file URL.
    private static func getFileURL(fileName: String) -> URL {
        // Get the URL of the Documents Directory
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // Get the URL for a file in the Documents Directory
        let documentDirectory = urls[0]
        return documentDirectory.appendingPathComponent(fileName + ".json")
    }
    
}
