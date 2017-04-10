//
//  Notification.swift
//  SWSG
//
//  Created by dinhvt on 10/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation

class PushNotification {
    
    public let type: PushNotificationType
    public let additionData: [String: Any]
    public let message: String
    
    init(type: PushNotificationType, additionData: [String: Any], message: String) {
        self.type = type
        self.additionData = additionData
        self.message = message
    }
    
    public func toDictionary() -> [String: Any] {
        var result = [String: Any]()
        result["aps"] = ["body": message]
        result["type"] = type.rawValue
        result["addition_data"] = additionData
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
