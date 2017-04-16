//
//  HttpClient.swift
//  SWSG
//
//  Created by dinhvt on 9/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

/**
    HttpClient is a simple HttpClient that will be used mainly by NotiPusher to contact with OneSignal server.
 */

import Foundation

class HttpClient {
    
    typealias PostCallback = (String?, HttpClientError?) -> Void
    
    // /**
    //     Send a GET request to the url represented by url string
    // */
    // public func get(urlString: String) {
    //     let url = URL(string: urlString)
        
    //     let task = URLSession.shared.dataTask(with: url!) { data, response, error in
    //         guard error == nil else {
    //             print(error!)
    //             return
    //         }
    //         guard let data = data else {
    //             print("Data is empty")
    //             return
    //         }
            
    //         let json = try! JSONSerialization.jsonObject(with: data, options: [])
    //         print(json)
    //     }
        
    //     task.resume()
    // }
    
    /**
        Post the data represented by jsonData to the url represented by urlString.
        The authHeaderValue also need to be provided. The response and any error will be passed to completion.
    */
    public func post(urlString: String, jsonData: Any, authHeaderValue: String, completion: PostCallback?) {
        let data = try! JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(authHeaderValue, forHTTPHeaderField: "Authorization")
        request.httpBody = data
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // check for fundamental networking error
            guard let data = data, error == nil else {
                completion?(nil, .networkError)
                return
            }
            
            // check for http errors
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                completion?(nil, .httpError)
            }
            
            let responseString = String(data: data, encoding: .utf8)
            completion?(responseString, nil)
        }
        
        task.resume()
    }
}

enum HttpClientError: Error {
    case networkError
    case httpError
}
