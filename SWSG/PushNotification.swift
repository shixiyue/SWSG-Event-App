//
//  Notification.swift
//  SWSG
//
//  Created by dinhvt on 10/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation
import OneSignal
import Firebase

/**
    PushNotification store information nessessarty to send and received push notification.
    The content of additionData is agreed between NotiPusher and NotiHandler.
    Fields: 
        - type: represent the type of the noti
        - additionData: additionData necessary to handle the notification.
        - message: a string that will be displayed by the notification by iOS.
    Invariant: 
        - The type of the notification decide the type, content and format of additionData
            + type announcement has and empty additionData
            + type message has additionData has only 1 key-value pair (Config.channelId: id)
*/

class PushNotification {
    
    public let type: PushNotificationType
    public let additionData: [String: Any]
    public let message: String
    
    init(type: PushNotificationType, additionData: [String: Any], message: String) {
        self.type = type
        self.additionData = additionData
        self.message = message
    }
    
    init?(snapshot: FIRDataSnapshot) {
        guard let data = snapshot.value as? [String: AnyObject] else {
            return nil
        }
        guard let rawType = data[Config.notiType] as? Int else {
            return nil
        }
        guard let type = PushNotificationType(rawValue: rawType) else {
            return nil
        }
        self.type = type
        guard let additionData = data[Config.notiAdditionData] as? [String: Any] else {
            return nil
        }
        self.additionData = additionData
        guard let message = data[Config.notiMessage] as? String else {
            return nil
        }
        self.message = message
    }

    init?(sendableDict: [String: Any]) {
        guard let contents = sendableDict[Config.notiContents] as? [String: String] else {
            return nil
        }
        guard let message = contents[Config.english] as String? else {
            return nil
        }
        self.message = message
        guard let data = sendableDict[Config.notiData] as? [String: Any] else {
            return nil
        }
        guard let rawType = data[Config.notiType] as? Int else {
            return nil
        }
        guard let type = PushNotificationType(rawValue: rawType) else {
            return nil
        }
        self.type = type
        guard let additionData = data[Config.notiAdditionData] as? [String: Any] else {
            return nil
        }
        self.additionData = additionData
    }
    
    init?(noti: OSNotification) {
        guard let message = noti.payload.body else {
            return nil
        }
        self.message = message
        guard let data = noti.payload.additionalData as? [String: Any] else {
            return nil
        }
        guard let rawType = data[Config.notiType] as? Int else {
            return nil
        }
        guard let type = PushNotificationType(rawValue: rawType) else {
            return nil
        }
        self.type = type
        guard let additionData = data[Config.notiAdditionData] as? [String: Any] else {
            return nil
        }
        self.additionData = additionData
    }
    
    public func toDictionary() -> [String: Any] {
        var result = [String: Any]()
        result[Config.notiType] = self.type
        result[Config.notiAdditionData] = self.additionData
        result[Config.notiMessage] = self.message
        return result
    }
    
    public func toSendableDict() -> [String: Any] {
        var result = [String: Any]()
        result[Config.notiContents] = [Config.english: message]
        var toBeSentData = [String: Any]()
        toBeSentData[Config.notiType] = type.rawValue
        toBeSentData[Config.notiAdditionData] = additionData
        result[Config.notiData] = toBeSentData
        return result
    }
    
}

enum PushNotificationType: Int {
    case announcement = 0
    case message = 1
}
