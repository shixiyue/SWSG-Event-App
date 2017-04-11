//
//  NotiPusher.swift
//  SWSG
//
//  Created by dinhvt on 9/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation
import OneSignal

class NotiPusher {
    
    public func pushToAll(noti: PushNotification) {
        var data = noti.toSendableDict()
        data["app_id"] = Secret.oneSignalAppId
        data["included_segments"] = ["All"]
        let http = HttpClient()
        http.post(urlString: "https://onesignal.com/api/v1/notifications", jsonData: data, authHeaderValue: Secret.oneSignalAuthHeaderValue, completion: nil)
        
    }
    
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
    
    public func crawlNoti() {
        let http = HttpClient()
        http.get(urlString: "https://onesignal.com/api/v1/notifications?app_id=\(Secret.oneSignalAppId)&limit=limit&offset=offset", authHeaderValue: Secret.oneSignalAuthHeaderValue)
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
    
    public func handleNoti(_ osNoti: OSNotification) {
        print("body")
        print(osNoti.payload.body)
        print("data")
        print(osNoti.payload.additionalData)
        guard let noti = PushNotification(noti: osNoti) else {
            return
        }
        print("noti obj")
        print(noti)
        switch noti.type {
        case .announcement:
            handleAnnouncement(noti)
        default:
            handleMessage(noti)
        }
    }
    
    private func handleAnnouncement(_ noti: PushNotification) {
        
    }
    
    private func handleMessage(_ noti: PushNotification) {
        
    }
    
}
