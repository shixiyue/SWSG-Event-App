//
//  Comments.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/17/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

/**
Comments is a class which is a local cache for all comments
Singleton pattern applied.
 
 -parameter:
     -`comments`: a mutable object which stores a dictionary of comments for a single event,
                  key is event name, [comment] is a list of comments under that event
*/

import UIKit

class Comments {

    public static var comments = [String: [Comment]]() {
        didSet {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "comments"), object: self)
        }
    }
}
