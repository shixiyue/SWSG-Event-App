//
//  NotiHandler.swift
//  SWSG
//
//  Created by dinhvt on 11/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation
import OneSignal

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
        case .message:
            handleMessage(noti)
        }
    }
    
    private func handleAnnouncement(_ noti: PushNotification) {
        
    }
    
    private func handleMessage(_ noti: PushNotification) {
        guard let channelId = noti.additionData[Config.channelId] else {
            return
        }
    }
    
}
