//
//  Notification.swift
//  SWSG
//
//  Created by dinhvt on 10/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation
import OneSignal

class PushNotification {
    
    public let type: PushNotificationType
    public let additionData: [String: Any]
    public let message: String
    
    init(type: PushNotificationType, additionData: [String: Any], message: String) {
        self.type = type
        self.additionData = additionData
        self.message = message
    }
    
    init?(sendableDict: [String: Any]) {
        guard let contents = sendableDict["contents"] as? [String: String] else {
            return nil
        }
        guard let message = contents["en"] as String? else {
            return nil
        }
        self.message = message
        guard let data = sendableDict["data"] as? [String: Any] else {
            return nil
        }
        guard let rawType = data["type"] as? Int else {
            return nil
        }
        guard let type = PushNotificationType(rawValue: rawType) else {
            return nil
        }
        self.type = type
        guard let additionData = data["addition_data"] as? [String: Any] else {
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
        guard let rawType = data["type"] as? Int else {
            return nil
        }
        guard let type = PushNotificationType(rawValue: rawType) else {
            return nil
        }
        self.type = type
        guard let additionData = data["addition_data"] as? [String: Any] else {
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
        result["contents"] = ["en": message]
        var toBeSentData = [String: Any]()
        toBeSentData["type"] = type.rawValue
        toBeSentData["addition_data"] = additionData
        result["data"] = toBeSentData
        return result
    }
    
}

enum PushNotificationType: Int {
    case announcement = 0
    case message = 1
}
