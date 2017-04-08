//
//  FBUser.swift
//  SWSG
//
//  Created by Jeremy Jee on 8/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation

struct FBUser {
    var id: String
    var name: String
    var email: String
    
    init(id: String, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }
    
    init?(snapshot: Any) {
        guard let snapshot = snapshot as? [String: String] else {
            return nil
        }
        
        guard snapshot.keys.contains(Config.id), let id = snapshot[Config.id] else {
            return nil
        }
        self.id = id
        
        guard snapshot.keys.contains(Config.name), let name = snapshot[Config.name] else {
            return nil
        }
        self.name = name
        
        guard snapshot.keys.contains(Config.email), let email = snapshot[Config.email] else {
            return nil
        }
        self.email = email
    }
    
    func getProfileImage() -> UIImage? {
        let urlString = "https://graph.facebook.com/\(id)/picture?type=large&return_ssl_resources=1"
        guard let imageURL = URL(string: urlString), let imageData = try? Data(contentsOf: imageURL) else {
            return nil
        }
        
        let image = UIImage(data: imageData)
        
        return image
    }
}
