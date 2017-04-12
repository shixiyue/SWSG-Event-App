//
//  Idea.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/23/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class Idea: ImagesContent, TemplateContent {
    
    var votes: Int { return upvotes.count - downvotes.count }
    var teamName: String { return "by Team "/*\(Teams.sharedInstance().retrieveTeamWith(id: team)!.name)"*/ }
    
    var id: String?

    public private(set) var name: String
    public private(set) var team: String
    public private(set) var description: String
    public private(set) var mainImage: UIImage = Config.defaultIdeaImage
    public internal(set) var images: [UIImage] = []
    public private(set) var videoLink: String

    public internal(set) var imagesState = IdeasImagesState()
    
    fileprivate var upvotes = Set<String>()
    fileprivate var downvotes = Set<String>()

    private var done = false
    private var imagesURL: [String: String]?
    private var imagesDict = [String: UIImage]()

    init(name: String, team: String, description: String, mainImage: UIImage, images: [UIImage], videoLink: String, id: String? = nil) {

        self.name = name
        self.team = team
        self.description = description
        self.mainImage = mainImage
        self.images = images
        self.videoLink = videoLink
        self.id = id
        
        if mainImage == Config.defaultIdeaImage {
            imagesState.mainImageHasChanged = false
        }
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
        guard let team = snapshotValue[Config.team] as? String else {
            return nil
        }
        self.team = team
        guard let description = snapshotValue[Config.description] as? String else {
            return nil
        }
        self.description = description
        guard let videoLink = snapshotValue[Config.videoLink] as? String else {
            return nil
        }
        self.videoLink = videoLink
        if let votes = snapshotValue[Config.votes] as? [String: Bool] {
            for (user, vote) in votes {
                if vote == true {
                    upvotes.insert(user)
                } else {
                    downvotes.insert(user)
                }
            }
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
    }
    
    func loadMainImage(completion: @escaping (Bool) -> Void) {
        guard let mainImageURL = imagesState.mainImageURL, !imagesState.mainImageHasFetched else {
            completion(false)
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
        })
    }
    
    func getUpdatedIdea(name: String, description: String, mainImage: UIImage, images: [UIImage], videoLink: String) -> Idea {
        let idea = Idea(name: name, team: team, description: description, mainImage: mainImage, images: images, videoLink: videoLink, id: id)
        idea.imagesState.mainImageHasChanged = self.mainImage != mainImage
        idea.imagesState.imagesHasChanged = self.images != images
        return idea
    }
    
    func update(name: String, description: String, mainImage: UIImage, images: [UIImage], videoLink: String) {
        self.name = name
        self.description = description
        self.mainImage = mainImage
        self.images = images
        self.videoLink = videoLink
    }
    
    func upvote() {
        guard let uid = System.activeUser?.uid, let id = id else {
            return
        }
        System.client.updateIdeaVote(for: id, user: uid, vote: true)
        guard !upvotes.contains(uid) else {
            upvotes.remove(uid)
            return
        }
        upvotes.insert(uid)
        if downvotes.contains(uid) {
            downvotes.remove(uid)
        }
    }
    
    func downvote() {
        guard let uid = System.activeUser?.uid, let id = id else {
            return
        }
        System.client.updateIdeaVote(for: id, user: uid, vote: false)
        guard !downvotes.contains(uid) else {
            downvotes.remove(uid)
            return
        }
        downvotes.insert(uid)
        if upvotes.contains(uid) {
            upvotes.remove(uid)
        }
    }
    
    func getVotingState() -> (upvote: Bool, downvote: Bool) {
        let uid = System.client.getUid()
        return (upvotes.contains(uid), downvotes.contains(uid))
    }
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [Config.name: self.name,
                                   Config.team: self.team,
                                   Config.description: self.description,
                                   Config.videoLink: self.videoLink]
        if let id = id {
            dict[Config.id] = id
        }
        return dict
    }
    
    private func _checkRep() {
        assert(upvotes.intersection(downvotes).isEmpty)
    }
    
}

extension Idea: Equatable { }

func ==(lhs: Idea, rhs: Idea) -> Bool {
    
    if let lhsId = lhs.id, let rhsId = rhs.id {
        return lhsId == rhsId
    }
    return lhs.name == rhs.name
        && lhs.team == rhs.team
        && lhs.description == rhs.description
        && lhs.mainImage == rhs.mainImage
        && lhs.images == rhs.images
        && lhs.videoLink == rhs.videoLink
        && lhs.upvotes == rhs.upvotes
        && lhs.downvotes == rhs.downvotes
}
