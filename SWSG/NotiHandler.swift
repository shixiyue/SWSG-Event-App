//
//  NotiHandler.swift
//  SWSG
//
//  Created by dinhvt on 11/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation
import OneSignal

/**
    NotiHandler is a class that provide method to handle notifications received by the app.
 */

class NotiHandler {
    
    public func handleNoti(_ osNoti: OSNotification) {
        guard let noti = PushNotification(noti: osNoti) else {
            return
        }
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
