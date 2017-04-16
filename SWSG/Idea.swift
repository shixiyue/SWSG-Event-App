//
//  Idea.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/23/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

/**
 Idea is a class that represents an Idea in the Idea System
 
 Specifications:
 - votes: A dynamic variable to tally what is the idea's voting score
 - id: The ID of the Idea as given by Firebase
 - name: Name of the Idea
 - user: User ID of the Idea Creator
 - description: Description of the Idea
 - mainImage: Main Image Icon of the Idea
 - images: Image Array of supplementary images as details
 - videoLink: Link to an embedded video
 - imagesState: Store whether images have been fetched or changed
 - upvotes: A Set containing the User IDs of people who upvoted
 - downvotes: A Set containing the User IDs of people who downvoted
 
 Representation Invariant:
 - There should not be any users who both upvoted and downvoted
 */
class Idea: ImagesContent, TemplateContent {
    
    var votes: Int { return upvotes.count - downvotes.count }
    
    var id: String?

    public private(set) var name: String
    public private(set) var user: String
    public private(set) var description: String
    public private(set) var mainImage: UIImage = Config.defaultIdeaImage
    public internal(set) var images: [UIImage] = []
    public private(set) var videoLink: String

    public internal(set) var imagesState = IdeasImagesState()
    
    fileprivate var upvotes = Set<String>()
    fileprivate var downvotes = Set<String>()

    init(name: String, user: String, description: String, mainImage: UIImage,
         images: [UIImage], videoLink: String, id: String? = nil) {

        self.name = name
        self.user = user
        self.description = description
        self.mainImage = mainImage
        self.images = images
        self.videoLink = videoLink
        self.id = id
        
        if mainImage == Config.defaultIdeaImage {
            imagesState.mainImageHasChanged = false
        }
        _checkRep()
    }
    
    init?(snapshotValue: [String: Any]) {
        guard let id = snapshotValue[Config.id] as? String else {
            return nil
        }
        self.id = id
        guard let name = snapshotValue[Config.name] as? String else {
            return nil
        }
        self.name = name
        guard let user = snapshotValue[Config.user] as? String else {
            return nil
        }
        self.user = user
        guard let description = snapshotValue[Config.description] as? String else {
            return nil
        }
        self.description = description
        guard let videoLink = snapshotValue[Config.videoLink] as? String else {
            return nil
        }
        self.videoLink = videoLink
        if let votes = snapshotValue[Config.votes] as? [String: Bool] {
            setVotes(votes: votes)
        }
        if let mainImageURL = snapshotValue[Config.mainImage] as? String {
            imagesState.mainImageURL = mainImageURL
        } else {
            imagesState.mainImageHasFetched = true
        }
        guard let imagesURL = snapshotValue[Config.images] as? [String: String], imagesURL.count > 0 else {
            imagesState.imagesHasFetched = true
            return
        }
        self.images = [Config.loadingImage]
        imagesState.imagesURL = imagesURL
        _checkRep()
    }
    
    func loadMainImage(completion: @escaping (Bool) -> Void) {
        _checkRep()
        guard let mainImageURL = imagesState.mainImageURL, !imagesState.mainImageHasFetched else {
            completion(false)
            _checkRep()
            return
        }
        Utility.getImage(name: mainImageURL, completion: { (image) in
            guard let image = image else {
                completion(false)
                return
            }
            self.mainImage = image
            self.imagesState.mainImageHasFetched = true
            completion(true)
            _checkRep()
        })
    }
    
    func getUpdatedIdea(name: String, description: String, mainImage: UIImage,
                        images: [UIImage], videoLink: String) -> Idea {
        _checkRep()
        let idea = Idea(name: name, user: user, description: description,
                        mainImage: mainImage, images: images, videoLink: videoLink, id: id)
        idea.imagesState.mainImageHasChanged = self.mainImage != mainImage
        idea.imagesState.imagesHasChanged = self.images != images
        _checkRep()
        return idea
    }
    
    func update(name: String, description: String, mainImage: UIImage, images: [UIImage], videoLink: String) {
        _checkRep()
        self.name = name
        self.description = description
        self.mainImage = mainImage
        self.images = images
        self.videoLink = videoLink
        _checkRep()
    }
    
    func setVotes(votes: [String: Bool]) {
        _checkRep()
        for (user, vote) in votes {
            if vote {
                upvotes.insert(user)
            } else {
                downvotes.insert(user)
            }
        }
        _checkRep()
    }
    
    func upvote() {
        _checkRep()
        guard let uid = System.activeUser?.uid, let id = id else {
            _checkRep()
            return
        }
        guard !upvotes.contains(uid) else {
            System.client.removeIdeaVote(for: id, user: uid)
            upvotes.remove(uid)
            _checkRep()
            return
        }
        System.client.updateIdeaVote(for: id, user: uid, vote: true)
        upvotes.insert(uid)
        if downvotes.contains(uid) {
            downvotes.remove(uid)
        }
        _checkRep()
    }
    
    func downvote() {
        _checkRep()
        guard let uid = System.activeUser?.uid, let id = id else {
            _checkRep()
            return
        }
        guard !downvotes.contains(uid) else {
            System.client.removeIdeaVote(for: id, user: uid)
            downvotes.remove(uid)
            _checkRep()
            return
        }
        System.client.updateIdeaVote(for: id, user: uid, vote: false)
        downvotes.insert(uid)
        if upvotes.contains(uid) {
            upvotes.remove(uid)
        }
        _checkRep()
    }
    
    func getVotingState() -> (upvote: Bool, downvote: Bool) {
        _checkRep()
        guard let uid = System.client.getUid() else {
            return (false, false)
        }
        _checkRep()
        
        return (upvotes.contains(uid), downvotes.contains(uid))
    }
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [Config.name: self.name,
                                   Config.user: self.user,
                                   Config.description: self.description,
                                   Config.videoLink: self.videoLink]
        if let id = id {
            dict[Config.id] = id
        }
        return dict
    }
    
    private func _checkRep() {
        #if DEBUG
        assert(upvotes.intersection(downvotes).isEmpty)
        #endif
    }
    
}

extension Idea: Equatable { }

func == (lhs: Idea, rhs: Idea) -> Bool {
    
    if let lhsId = lhs.id, let rhsId = rhs.id {
        return lhsId == rhsId
    }
    return lhs.name == rhs.name
        && lhs.user == rhs.user
        && lhs.description == rhs.description
        && lhs.mainImage == rhs.mainImage
        && lhs.images == rhs.images
        && lhs.videoLink == rhs.videoLink
        && lhs.upvotes == rhs.upvotes
        && lhs.downvotes == rhs.downvotes
}
