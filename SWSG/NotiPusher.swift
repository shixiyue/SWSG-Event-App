//
//  NotiPusher.swift
//  SWSG
//
//  Created by dinhvt on 9/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

/**
    NotiPusher is the interface between the app and OneSignal that can send request to OneSignal server to send notifications to other users.
 */

import Foundation
import OneSignal

class NotiPusher {
    
    /**
        Send the noti to all user.
            - requires: the type of noti must have the type that is available to all user (.i.e announcement)
    */
    public func pushToAll(noti: PushNotification) {
        var data = noti.toSendableDict()
        data["app_id"] = Secret.oneSignalAppId
        data["included_segments"] = ["All"]
        let http = HttpClient()
        http.post(urlString: "https://onesignal.com/api/v1/notifications", jsonData: data, authHeaderValue: Secret.oneSignalAuthHeaderValue, completion: nil)
        
    }
    
    /**
        
    */    
    public func push(noti: PushNotification, toUserWithUid uid: String) {
        var data = noti.toSendableDict()
        data["app_id"] = Secret.oneSignalAppId
        //data["included_segments"] = ["All"]
        data["filters"] = [["field": "tag", "key": "uid", "relation": "=", "value": uid]]
        let http = HttpClient()
        http.post(urlString: "https://onesignal.com/api/v1/notifications", jsonData: data, authHeaderValue: Secret.oneSignalAuthHeaderValue, completion: nil)
    }
    
    public func push(noti: PushNotification, toUserWithEmail: String) {
        var data = noti.toSendableDict()
        data["app_id"] = Secret.oneSignalAppId
        //data["included_segments"] = ["All"]
        data["filters"] = [["field": "email", "relation": "=", "value": toUserWithEmail]]
        let http = HttpClient()
        http.post(urlString: "https://onesignal.com/api/v1/notifications", jsonData: data, authHeaderValue: Secret.oneSignalAuthHeaderValue, completion: nil)
    }
    
}

enum UserGroup {
    case all
    case individual
    case admin
    case mentor
    case organizer
    case speak
    case participant
}

class NotiHandler {
    
    public func handleNoti(_ noti: OSNotification) {
        print("body")
        print(noti.payload.body)
        print("data")
        print(noti.payload.additionalData)
    }
    
}
