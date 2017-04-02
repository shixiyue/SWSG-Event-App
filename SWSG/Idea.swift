//
//  Idea.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/23/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class Idea {
    
    public private(set) var name: String
    public private(set) var team: Int
    public private(set) var description: String
    public private(set) var mainImage: UIImage
    public private(set) var images: [UIImage]
    public private(set) var videoLink: String
    
    var votes: Int {
        get {
            return upvotes.count - downvotes.count
        }
    }
    
    var teamName: String {
        get {
            return "by Team \(Teams.sharedInstance().retrieveTeamAt(index: team).name)"
        }
    }
    
    private var upvotes = Set<String>()
    private var downvotes = Set<String>()
    
    init(name: String, team: Int, description: String, mainImage: UIImage, images: [UIImage], videoLink: String) {
        self.name = name
        self.team = team
        self.description = description
        self.mainImage = mainImage
        self.images = images
        self.videoLink = videoLink
    }
    
    func upvote() {
        let uid = System.client.getUid()
        if upvotes.contains(uid) {
            upvotes.remove(uid)
        } else {
            upvotes.insert(uid)
            if downvotes.contains(uid) {
                downvotes.remove(uid)
            }
        }
    }
    
    func downvote() {
        let uid = System.client.getUid()
        if downvotes.contains(uid) {
            downvotes.remove(uid)
        } else {
            downvotes.insert(uid)
            if upvotes.contains(uid) {
                upvotes.remove(uid)
            }
        }
    }
    
    func getVotingState() -> (upvote: Bool, downvote: Bool) {
        let uid = System.client.getUid()
        return (upvotes.contains(uid), downvotes.contains(uid))
    }
    
    func toDictionary() -> [String: Any] {
        return ["ideaName": self.name, "ideaTeam": self.team, "ideaDescription": self.description, "ideaVideo": self.videoLink, "votes": votes]
    }

}
