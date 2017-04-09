//
//  FBUser.swift
//  SWSG
//
//  Created by Jeremy Jee on 8/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation
import GoogleSignIn

struct SocialUser {
    var id: String
    var name: String
    var email: String
    var type: AuthType
    
    init(id: String, name: String, email: String, type: AuthType) {
        self.id = id
        self.name = name
        self.email = email
        self.type = type
    }
    
    init(gUser: GIDGoogleUser) {
        self.id = gUser.userID
        self.name = gUser.profile.name
        self.email = gUser.profile.email
        self.type = .google
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
