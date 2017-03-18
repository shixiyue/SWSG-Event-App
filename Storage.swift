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
    
    /// save the current user to the local device, so that device can recognize user when he/she posts a comment or chat message
    static func saveCurrentUserToLocal(user: User) {
        let dataToSave = NSMutableData()
        let archiver = NSKeyedArchiver.init(forWritingWith: dataToSave)
        archiver.encode(user.profile.name, forKey: Config.localUser)
        archiver.finishEncoding()
        
        let isSuccessfulSave=dataToSave.write(to: getLocalFileURL(fileName: Config.localUser), atomically: true)
        if isSuccessfulSave{
            print("current username \(user.profile.name) saved successfully")
        }
    }
    
    /// read the current user from the local device, to facilitate the device recognize user when he/she posts a comment or chat message
    static func readCurrentUserFromLocal() -> String? {
        guard let retrievedData = NSData(contentsOfFile: getLocalFileURL(fileName: Config.localUser).path) else {
            print("retrieve from local user failed")
            return nil
        }
        let unarchiver = NSKeyedUnarchiver.init(forReadingWith: retrievedData as Data)
        let username = unarchiver.decodeObject(forKey: Config.localUser) as? String
        return username
    }
    
    /// Gets the file URL in JSON
    private static func getFileURL(fileName: String) -> URL {
        // Get the URL of the Documents Directory
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // Get the URL for a file in the Documents Directory
        let documentDirectory = urls[0]
        return documentDirectory.appendingPathComponent(fileName + ".json")
    }
    
    /// Gets the file URL
    private static func getLocalFileURL(fileName: String) -> URL {
        // Get the URL of the Documents Directory
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // Get the URL for a file in the Documents Directory
        let documentDirectory = urls[0]
        return documentDirectory.appendingPathComponent(fileName)
    }
    
    /// save comments into a json file with the `fileName` specified
    static func saveComments(data: [String:[Comment]], fileName: String) {
        do {
            var localData = [String: [[String:String]]]()
            for event in data.keys {
                var alldic = [[String: String]]()
                for comment in data[event]! {
                    var dic = [String: String]()
                    dic.updateValue(comment.username, forKey: "username")
                    dic.updateValue(comment.words, forKey: "words")
                    alldic.append(dic)
                }
                localData.updateValue(alldic, forKey: event)
            }
            let jsonData = try JSONSerialization.data(withJSONObject: localData, options: JSONSerialization.WritingOptions())
            try jsonData.write(to: getFileURL(fileName: fileName))
            print("comments saved successfully")
        } catch _ {
            print("comment saved failed")
        }
    }
    
    /// read comments from the `fileName`
    static func readComments(fileName: String) -> [String:[Comment]]? {
        guard let jsonData = try? Data(contentsOf: getFileURL(fileName: fileName)) else {
            return nil
        }
        guard let data = try? JSONSerialization.jsonObject(with: jsonData as Data, options: .allowFragments), let comments = data as? [String:[[String:String]]] else {
            return nil
        }

        var localData = [String: [Comment]]()
        for event in comments.keys {
            var dic = [Comment]()
            for comment in comments[event]! {
                let username = comment["username"]
                let words = comment["words"]
                dic.append(Comment(words: words!, username: username!))
            }
            localData.updateValue(dic, forKey: event)
        }
        return localData
    }
}

