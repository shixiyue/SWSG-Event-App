//
//  IdeaImagesState.swift
//  SWSG
//
//  Created by Shi Xiyue on 11/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation

class ImagesState {

    var imagesHasChanged = true
    var imagesHasFetched = false
    
    var imagesURL: [String: String]?
    var imagesDict = [String: UIImage]()
    
}

class IdeasImagesState: ImagesState {
    
    var mainImageHasChanged = true
    var mainImageHasFetched = false
    var mainImageURL: String?
    
}
