//
//  PhotoList.swift
//  SWSG
//
//  Created by Shi Xiyue on 25/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Firebase

/**
 OverviewContent is a class that represents an OverviewContent in the Information System
 
 Specifications:
 - id: The ID of the content, which is to comfrom protocol ImagesContent
 - description: Description of the Idea
 - images: Image Array of supplementary images as details
 - videoLink: Link to an embedded video
 - imagesState: Store whether images have been fetched or changed
 
 Representation Invariant:
 - The description cannot be empty.
 */
class OverviewContent: ImagesContent, TemplateContent {
    
    var id: String? = "overview"
    public private(set) var description: String = Config.defaultContent
    public private(set) var videoLink: String = Config.emptyString
    
    public internal(set) var images: [UIImage] = []
    public internal(set) var imagesState = ImagesState()
    
    init() {}
    
    init(description: String, images: [UIImage], videoLink: String) {
        self.description = description
        self.images = images
        self.videoLink = videoLink
        _checkRep()
    }
    
    init(snapshot: FIRDataSnapshot) {
        guard let snapshotValue = snapshot.value as? [String: Any] else {
            return
        }
        if let description = snapshotValue[Config.description] as? String {
            self.description = description
        }
        if let videoLink = snapshotValue[Config.videoLink] as? String {
            self.videoLink = videoLink
        }
        guard let imagesURL = snapshotValue[Config.images] as? [String: String], imagesURL.count > 0 else {
            imagesState.imagesHasFetched = true
            return
        }
        self.images = [Config.loadingImage]
        imagesState.imagesURL = imagesURL
        _checkRep()
    }

    func getUpdatedOverview(description: String, images: [UIImage], videoLink: String) -> OverviewContent {
        _checkRep()
        let updatedOverview = OverviewContent(description: description, images: images, videoLink: videoLink)
        updatedOverview.imagesState.imagesHasChanged = self.images != images
        _checkRep()
        return updatedOverview
    }
    
    func update(description: String, images: [UIImage], videoLink: String) {
        _checkRep()
        self.description = description
        self.images = images
        self.videoLink = videoLink
        _checkRep()
    }
    
    func toDictionary() -> [String: String] {
        return [Config.description: description, Config.videoLink: videoLink]
    }
    
    private func _checkRep() {
        #if DEBUG
        assert(!description.isEmpty)
        #endif
    }
    
}
