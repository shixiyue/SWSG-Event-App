//
//  IdeaImagesState.swift
//  SWSG
//
//  Created by Shi Xiyue on 11/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation

struct ImagesState {
    
    var mainImageHasChanged = true
    var imagesHasChanged = true
    
    var mainImageHasFetched = false
    var imagesHasFetched = false
    
    var mainImageURL: String?
    var imagesURL: [String: String]?
    var imagesDict = [String: UIImage]()
    
}
