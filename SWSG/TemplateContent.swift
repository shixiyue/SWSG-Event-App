//
//  TemplateContent.swift
//  SWSG
//
//  Created by Shi Xiyue on 12/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//


/**
 TemplateContent is a protocol that represents a template content,
 which will be shown in TemplateViewController.
 
 Specifications:
 - description: Description of the Content
 - images: Image Array of supplementary images as details
 - videoLink: Link to an embedded video
 
 Representation Invariant:
 - None
 */
protocol TemplateContent: class {
    
    var description: String { get }
    var images: [UIImage] { get }
    var videoLink: String { get }
    
}
