//
//  ImagesContent.swift
//  SWSG
//
//  Created by Shi Xiyue on 11/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//


/**
 ImagesContent is a protocol that represents a content which has multiple images.
 It has some default implementation to fetch images.

 Specifications:
 - id: The ID of the content, to be used for notification
 - images: Image Array of supplementary images as details
 - imagesState: Store whether images have been fetched or changed
 
 Representation Invariant:
 - None
 */
protocol ImagesContent: class {
    associatedtype State: ImagesState
    
    var id: String? { get }
    var images: [UIImage] { get set }
    var imagesState: State { get set }
    
    func loadImages()
}

extension ImagesContent {
    
    /// Loads images for the content.
    func loadImages() {
        guard let imagesURL = imagesState.imagesURL else {
            return
        }
        loadImages(generator: imagesURL.makeIterator())
    }
    
    private func loadImages(generator: DictionaryIterator<String, String>) {
        var generator = generator
        guard let (key, url) = generator.next() else {
            setImages()
            return
        }
        guard !imagesState.imagesHasFetched else {
            return
        }
        Utility.getImage(name: url, completion: { (image) in
            if let image = image {
                self.imagesState.imagesDict[key] = image
            }
            self.loadImages(generator: generator)
        })
    }
    
    private func setImages() {
        if imagesState.imagesHasFetched {
            return
        }
        imagesState.imagesHasFetched = true
        let array = imagesState.imagesDict.sorted(by: { $0.0 < $1.0 }) // Sorts images by the id
        imagesState.imagesDict.removeAll()
        
        images = []
        for (_, image) in array {
            images.append(image)
        }
        
        guard let id = id else {
            return
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: id), object: nil)
    }

}
