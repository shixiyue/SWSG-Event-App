//
//  TemplateContent.swift
//  SWSG
//
//  Created by Shi Xiyue on 12/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

protocol TemplateContent: class {
    
    var description: String { get }
    var images: [UIImage] { get }
    var videoLink: String { get }
    
}
