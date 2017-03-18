//
//  Storage.swift
//  SWSG
//
//  Created by shixiyue on 13/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation

/// `Storage` represents the storage of SWSG App. It will comunicate with the backend.
struct Storage {
    
    /// Saves user data to a json file with the given filename.
    static func saveUser(data: Dictionary<String, String>, fileName: String) -> Bool {
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
        guard let data = try? JSONSerialization.jsonObject(with: jsonData as Data, options: .allowFragments), let userProfile = data as? Dictionary<String, String> else {
            return nil
        }
        guard let name = userProfile[Config.name], let job = userProfile[Config.job], let country =  userProfile[Config.country], let education = userProfile[Config.education], let skills = userProfile[Config.skills] else {
            return nil
        }
        let profile = Profile(name: name, job: job, country: country, education: education, skills: skills)
        guard let email = userProfile[Config.email], let password = userProfile[Config.password] else {
            return nil
        }
        return Participant(profile: profile, password: password, email: email, team: nil)
    }
    
    /// Gets the file URL.
    private static func getFileURL(fileName: String) -> URL {
        // Get the URL of the Documents Directory
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // Get the URL for a file in the Documents Directory
        let documentDirectory = urls[0]
        return documentDirectory.appendingPathComponent(fileName + ".json")
    }
    
    /// save comments into a json file with the `fileName` specified
    static func saveComments(data: [Comment], fileName: String) -> Bool {
        do {
            var arr = [[String: String]]()
            for i in data {
                var dic = [String: String]()
                dic.updateValue(i.username, forKey: "username")
                dic.updateValue(i.words, forKey: "words")
                arr.append(dic)
            }
            let jsonData = try JSONSerialization.data(withJSONObject: arr, options: JSONSerialization.WritingOptions())
            try jsonData.write(to: getFileURL(fileName: fileName))
            return true
        } catch _ {
            return false
        }
    }
    
    /// read comments from the `fileName`
    static func readComments(fileName: String) -> [Comment]? {
        guard let jsonData = try? Data(contentsOf: getFileURL(fileName: fileName)) else {
            return nil
        }
        guard let data = try? JSONSerialization.jsonObject(with: jsonData as Data, options: .allowFragments), let comments = data as? [[String:String]] else {
            return nil
        }
        var arr = [Comment]()
        for i in comments {
            let username = i["username"]
            let words = i["words"]
            arr.append(Comment(words: words!,username: username!))
        }
        return arr
    }

    
}
