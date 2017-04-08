//
//  Idea.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/23/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class Idea {
    
    var votes: Int { return upvotes.count - downvotes.count }
    var teamName: String { return "by Team \(Teams.sharedInstance().retrieveTeamAt(index: team).name)" }
    
    var id: String?
    
    public private(set) var name: String
    public private(set) var team: Int
    public private(set) var description: String
    public private(set) var mainImage: UIImage
    public private(set) var images: [UIImage]
    public private(set) var videoLink: String
    
    fileprivate var upvotes = Set<String>()
    fileprivate var downvotes = Set<String>()
    
    init(name: String, team: Int, description: String, mainImage: UIImage, images: [UIImage], videoLink: String) {
        self.name = name
        self.team = team
        self.description = description
        self.mainImage = mainImage
        self.images = images
        self.videoLink = videoLink
    }
    
    init?(snapshotValue: [String: Any]) {
        guard let id = snapshotValue[Config.id] as? String else {
            return nil
        }
        self.id = id
        guard let name = snapshotValue[Config.ideaName] as? String else {
            return nil
        }
        self.name = name
        guard let team = snapshotValue[Config.ideaTeam] as? Int else {
            return nil
        }
        self.team = team
        guard let description = snapshotValue[Config.ideaDescription] as? String else {
            return nil
        }
        self.description = description
        mainImage = UIImage()
        images = []
        guard let videoLink = snapshotValue[Config.ideaVideo] as? String else {
            return nil
        }
        self.videoLink = videoLink
        guard let votes = snapshotValue[Config.votes] as? [String: Bool] else {
            return
        }
        for (user, vote) in votes {
            if vote == true {
                upvotes.insert(user)
            } else {
                downvotes.insert(user)
            }
        }
    }
    
    func update(name: String, description: String, mainImage: UIImage, images: [UIImage], videoLink: String) {
        self.name = name
        self.description = description
        self.mainImage = mainImage
        self.images = images
        self.videoLink = videoLink
        System.client.updateIdeaContent(for: self)
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
        var dict: [String: Any] = [Config.ideaName: self.name,
                                   Config.ideaTeam: self.team,
                                   Config.ideaDescription: self.description,
                                   Config.ideaVideo: self.videoLink]
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
