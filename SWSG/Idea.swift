//
//  Idea.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/23/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class Idea {
    
    public private(set) var name: String
    public private(set) var team: String
    public private(set) var description: String
    public private(set) var mainImage: UIImage
    public private(set) var images: [UIImage]
    public private(set) var videoLink: String
    public private(set) var votes = 0
    
    init(name: String, team: String, description: String, mainImage: UIImage, images: [UIImage], videoLink: String) {
        self.name = name
        self.team = team
        self.description = description
        self.mainImage = mainImage
        self.images = images
        self.videoLink = videoLink
    }
    
    func toDictionary() -> [String: Any] {
        return ["ideaName": self.name, "ideaTeam": self.team, "ideaDescription": self.description, "ideaVideo": self.videoLink, "votes": votes]
    }

}
