//
//  FBRequest.swift
//  SWSG
//
//  Created by Jeremy Jee on 8/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import FacebookCore

struct FBRequest: GraphRequestProtocol {
    struct Response: GraphResponseProtocol {
        let user: SocialUser?
        init(rawResponse: Any?) {
            guard let response = rawResponse as? [String: Any] else {
                user = nil
                return
            }
            print(response)
            guard let id = response[Config.id] as? String,
                let name = response[Config.name] as? String,
                let email = response[Config.email] as? String else {
                user = nil
                return
            }
            
            user = SocialUser(id: id, name: name, email: email, type: .facebook)
        }
    }
    
    var graphPath = "/me"
    var parameters: [String : Any]? = ["fields": "id, name, email"]
    var accessToken = AccessToken.current
    var httpMethod: GraphRequestHTTPMethod = .GET
    var apiVersion: GraphAPIVersion = .defaultVersion
}
