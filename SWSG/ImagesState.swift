//
//  IdeaImagesState.swift
//  SWSG
//
//  Created by Shi Xiyue on 11/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation

/**
ImagesState is a class to indicate whether images have been fetched or changed. 
It helps to achieve a better performance for loading and uploading images.
 
 Specifications:
 - imagesHasChanged: Whether images have changed
 - imagesHasFetched: Whether images have fetched
 - imagesURL: A link to images
 - imagesDict: Fetched images
 
 Representation Invariant:
 - None
 */
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
