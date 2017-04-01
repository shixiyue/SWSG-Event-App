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
    
    // Temporary
    /// Need to check with database and get types that the user belongs to
    static func retrieveUserType(email: String) -> UserTypes {
        let isParticipant = checkParticipant(email: email)
        let isSpeaker = false
        let isMentor = false
        let isOrganizer = checkOrganizer(email: email)
        let isAdmin = checkAdmin(email: email)
        return UserTypes(isParticipant: isParticipant, isSpeaker: isSpeaker, isMentor: isMentor, isOrganizer: isOrganizer, isAdmin: isAdmin)
    }
    
    // Temporary hard-coded data:
    static let admin = "admin@swsg.com"
    
    // Temporary
    static func checkParticipant(email: String) -> Bool {
        return email != admin
    }
    
    static func checkOrganizer(email: String) -> Bool {
        return email == admin
    }
    
    static func checkAdmin(email: String) -> Bool {
        return email == admin
    }
    
    /// Saves user data to a json file with the given filename.
    static func saveUser(user: User) -> Bool {
        do {
            let data = user.toDictionary()
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions())
            try jsonData.write(to: getFileURL(fileName: user.email))
            guard let pngImageData = UIImagePNGRepresentation(user.profile.image) else {
                return false
            }
            try pngImageData.write(to: getLocalFileURL(fileName: "\(user.email).png"), options: .atomic)
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
        guard let email = userInfo[Config.email] as? String, let password = userInfo[Config.password] as? String, let profile = userInfo[Config.profile] as? [String: Any], let name = profile[Config.name] as? String, let country = profile[Config.country] as? String, let job = profile[Config.job] as? String, let company = profile[Config.company] as? String, let education = profile[Config.education] as? String, let skills = profile[Config.skills] as? String, let desc = profile[Config.desc] as? String, let type = profile[Config.userType] as? [String: Bool], let isParticipant = type[Config.isParticipant], let isSpeaker = type[Config.isSpeaker], let isMentor = type[Config.isMentor], let isOrganizer = type[Config.isOrganizer], let isAdmin = type[Config.isAdmin] else {
            return nil
        }
        let imageFilePath = getLocalFileURL(fileName: "\(email).png").path
        guard let image = UIImage(contentsOfFile: imageFilePath) else {
            return nil
        }
        let userType = UserTypes(isParticipant: isParticipant, isSpeaker: isSpeaker, isMentor: isMentor, isOrganizer: isOrganizer, isAdmin: isAdmin)
        guard let team_index = profile[Config.team] as? Int else {
            return nil
        }
        
        let userProfile = Profile(type: userType, team: team_index, name: name, image: image, job: job, company: company, country: country, education: education, skills: skills, description: desc)

        return User(profile: userProfile, password: password, email: email)
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
    
    static func saveTeams(data: [Team], fileName: String) {
        
        do {
            var localData = [[String: Any]]()
            for i in data {
                localData.append(i.toDictionary())
            }
            let jsonData = try JSONSerialization.data(withJSONObject: localData, options: JSONSerialization.WritingOptions())
            try jsonData.write(to: getFileURL(fileName: fileName))
            print("teams saved successfully")
        } catch _ {
            print("teams saved failed")
        }
    }
    
    static func readTeams(fileName: String) -> [Team]? {
        guard let jsonData = try? Data(contentsOf: getFileURL(fileName: fileName)) else {
            print("file does not exist")
            return nil
        }
        guard let data = try? JSONSerialization.jsonObject(with: jsonData as Data, options: .allowFragments), let teams_data = data as? [[String:Any]] else {
            print("wrong data format")
            return nil
        }
        var data_retrieved = [Team]()
        for teams in teams_data {
            var members_retrieved = [User]()
            guard let teamName = teams["teamName"] as? String, let info = teams["info"] as? String,let lookingFor = teams["lookingFor"] as? String, let isPrivate = teams["isPrivate"] as? Bool else {
                print("one of the attribute is nil")
                return nil
            }
            guard let members_data = teams["members"] as? [[String: Any]] else {
                return data_retrieved
            }
                for member in members_data {
                    guard let email = member[Config.email] as? String, let password = member[Config.password] as? String, let profile = member[Config.profile] as? [String: Any], let name = profile[Config.name] as? String, let country = profile[Config.country] as? String, let job = profile[Config.job] as? String, let company = profile[Config.company] as? String, let education = profile[Config.education] as? String, let skills = profile[Config.skills] as? String, let desc = profile[Config.desc] as? String, let type = profile[Config.userType] as? [String: Bool], let isParticipant = type[Config.isParticipant], let isSpeaker = type[Config.isSpeaker], let isMentor = type[Config.isMentor], let isOrganizer = type[Config.isOrganizer], let isAdmin = type[Config.isAdmin] else {
                        print("one of user attribute is nil")
               
                        return nil
                    }
                    let imageFilePath = getLocalFileURL(fileName: "\(email).png").path
                    guard let image = UIImage(contentsOfFile: imageFilePath) else {
                        print("user image is nil")
                        return nil
                    }
                    let userType = UserTypes(isParticipant: isParticipant, isSpeaker: isSpeaker, isMentor: isMentor, isOrganizer: isOrganizer, isAdmin: isAdmin)
                    guard let team_participant = member["team"] as? Int else {
                        return nil
                    }
                    let userProfile = Profile(type: userType, team: team_participant, name: name, image: image, job: job, company: company, country: country, education: education, skills: skills, description: desc)
                    let participant =  User(profile: userProfile, password: password, email: email)
                    members_retrieved.append(participant)
                }
                let team = Team(members: members_retrieved, name: teamName, info: info, lookingFor: lookingFor, isPrivate: isPrivate)
                data_retrieved.append(team)
        }
        print("data retrieved successfully")
        return data_retrieved
    }
    
    static func saveIdeas(data: [Idea], fileName: String) {
        do { /*
            var localData = [[String: String]]()
            for i in data {
                localData.append(i.toDictionary())
            }
            let jsonData = try JSONSerialization.data(withJSONObject: localData, options: JSONSerialization.WritingOptions())
            try jsonData.write(to: getFileURL(fileName: fileName))
            print("ideas saved successfully") */
        } catch _ {
            print("ideas saved failed")
        }

    }
    static func readIdeas(fileName: String) -> [Idea]? {
        guard let jsonData = try? Data(contentsOf: getFileURL(fileName: fileName)) else {
            return nil
        }
        guard let data = try? JSONSerialization.jsonObject(with: jsonData as Data, options: .allowFragments), let ideas = data as? [[String:String]] else {
            return nil
        }
        
        var localData = [Idea]()
        /*for idea in ideas {
           if let name = idea["ideaName"], let desc = idea["ideaDescription"], let teamNo = idea["ideaTeam"] {
                 localData.append(Idea(name: name, description: desc, team: teamNo))
            }
        }*/
        return localData
    }
}

