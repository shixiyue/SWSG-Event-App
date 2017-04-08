//
//  Person.swift
//  SWSG
//
//  Created by Shi Xiyue on 6/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation

struct Person {
    
    let photo: UIImage
    let name: String
    let title: String
    let intro: String
    
    init(photo: UIImage?, name: String, title: String, intro: String) {
        self.photo = photo ?? UIImage()
        self.name = name
        self.title = title
        self.intro = intro
    }
    
}
