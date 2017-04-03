//
//  IdeaItemTableViewCell.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/23/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class IdeaItemTableViewCell: UITableViewCell {
    
    @IBOutlet private var name: UILabel!
    @IBOutlet private var desc: UILabel!
    @IBOutlet private var team: UILabel!
    @IBOutlet private var ideaImageView: UIImageView!
    @IBOutlet private var votes: UILabel!
    @IBOutlet private var upvoteButton: UIButton!
    @IBOutlet private var downvoteButton: UIButton!
    
    private var idea: Idea!
    
    func setIdea(_ idea: Idea) {
        self.idea = idea
        name.text = idea.name
        desc.text = idea.description
        team.text = idea.teamName
        ideaImageView.image = idea.mainImage
        updateVotes()
    }

    @IBAction func upvote(_ sender: UIButton) {
        idea.upvote()
        updateVotes()
    }
    
    @IBAction func downvote(_ sender: UIButton) {
        idea.downvote()
        updateVotes()
    }
    
    private func updateVotes() {
        votes.text = "\(idea.votes)"
        let state = idea.getVotingState()
        let upvoteImage = state.upvote ? Config.upvoteFilled : Config.upvoteDefault
        upvoteButton.setImage(upvoteImage, for: .normal)
        let downvoteImage = state.downvote ? Config.downvoteFilled : Config.downvoteDefault
        downvoteButton.setImage(downvoteImage, for: .normal)
    }
    
}
