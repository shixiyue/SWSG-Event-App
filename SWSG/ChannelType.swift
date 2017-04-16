//
//  ChannelType.swift
//  SWSG
//
//  Created by Jeremy Jee on 6/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation

/**
 ChannelType is an class used to represent the type of channel
 
 Specifications:
    - publicChannel: Open to All Users (Only Admin can create)
    - privateChannel: Open only to Members
    - directMessage: Only between two people
    - team: Same as Private Channel except Channel Info cannot be edited
 */
enum ChannelType: String {
    case publicChannel
    case privateChannel
    case directMessage
    case team
}
