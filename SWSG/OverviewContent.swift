//
//  PhotoList.swift
//  SWSG
//
//  Created by Shi Xiyue on 25/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Firebase

class OverviewContent: ImagesContent, TemplateContent {
    
    var id: String? = "overview" // To conform the protocol
    public private(set) var description: String = Config.defaultContent
    public private(set) var videoLink: String = Config.emptyString
    
    public internal(set) var images: [UIImage] = []
    public internal(set) var imagesState = ImagesState()
    
    init() {}
    
    init(description: String, images: [UIImage], videoLink: String) {
        self.description = description
        self.images = images
        self.videoLink = videoLink
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
    }

    func getUpdatedOverview(description: String, images: [UIImage], videoLink: String) -> OverviewContent {
        let updatedOverview = OverviewContent(description: description, images: images, videoLink: videoLink)
        updatedOverview.imagesState.imagesHasChanged = self.images != images
        return updatedOverview
    }
    
    func update(description: String, images: [UIImage], videoLink: String) {
        self.description = description
        self.images = images
        self.videoLink = videoLink
    }
    
    func toDictionary() -> [String: String] {
        return [Config.description: description, Config.videoLink: videoLink]
    }
    
}
