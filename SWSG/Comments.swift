//
//  Comments.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/17/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//
///singleton pattern

import UIKit

class Comments {

    static var comments = [Comment]() {
        didSet {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "comments"), object: self)
  
            Storage.saveComments(data: comments, fileName: Config.commentsFileName)
        }
    }

    
}
