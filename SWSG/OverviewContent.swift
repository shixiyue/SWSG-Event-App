//
//  PhotoList.swift
//  SWSG
//
//  Created by Shi Xiyue on 25/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

struct OverviewContent {
    
    static var description = "Startup Weekend Singapore (SWSG) is an annual entrepreneurship event where over 150 attendees would gather  together and within 54 hours pitch a business proposal towards a panel of judges. The event is targetted at technologically-enabled startup enthusiasts and people who want to network with like-minded individuals. Throughout the 3 day event, participants would be  involved in idea creation, peer voting, keynote speeches, mentor consultations and finally presenting their own idea."
    static var images: [UIImage] = [UIImage(named: "event-image1")!, UIImage(named: "event-image2")!]
    static var videoLink = "https://www.youtube.com/embed/Lye_NuMugKQ"
    
    static func update(description: String, images: [UIImage], videoLink: String) {
        // Need to communicate with backend 
        self.description = description
        self.images = images
        self.videoLink = videoLink
    }
    
}
