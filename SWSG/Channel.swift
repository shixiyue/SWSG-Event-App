//
//  Chat.swift
//  SWSG
//
//  Created by Jeremy Jee on 23/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import Firebase

/**
 Channel is a class used to represent a Channel in the Chat System
 
 Specifications:
    - id: Channel ID as given by Firebase
    - type: The Type of Channel that is it using the ChannelType enum
    - icon: An Optional UIImage to represent the Icon for the chat
    - name: The Name of a Channel, not present if it is a direct message
    - latestMessage: The Latest Message in the Channel
    - members: An Array of Member's UIDs (String)
 
 Representation Invariant:
    - If the Channel is not a Direct Message, it should have a Name
 */
class Channel {
    var id: String?
    private (set) var type: ChannelType
    var icon: UIImage?
    var name: String?
    var latestMessage: Message?
    var members = [String]()
    
    init(id: String?, type: ChannelType, icon: UIImage?, name: String?, members: [String]) {
        self.id = id
        self.type = type
        self.icon = icon
        self.name = name
        self.members = members
        
        _checkRep()
    }
    
    convenience init(type: ChannelType, icon: UIImage?, name: String, members: [String]) {
        self.init(id: nil, type: type, icon: icon, name: name, members: members)
    }
    
    convenience init(type: ChannelType, members: [String]) {
        self.init(id: nil, type: type, icon: nil, name: nil, members: members)
    }
    
    init?(id: String, snapshot: FIRDataSnapshot) {
        self.id = id
        
        guard let snapshotValue = snapshot.value as? [String: AnyObject] else {
            return nil
        }
        
        if let name = snapshotValue[Config.name] as? String {
            self.name = name
        }
        
        guard let typeRaw = snapshotValue[Config.channelType] as? String,
            let type = ChannelType(rawValue: typeRaw) else {
            return nil
        }
        self.type = type
        
        guard let members = snapshotValue[Config.members] as? [String] else {
            return nil
        }
        self.members = members
        
        _checkRep()
    }
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [Config.channelType: type.rawValue, Config.members: members]
        
        if let name = name {
            dict[Config.name] = name
        }
        
        return dict
    }
    
    fileprivate func _checkRep() {
        if type != .directMessage && name == nil {
            assert(false)
        }
    }
    
}
