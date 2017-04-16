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
    @IBOutlet private var user: UILabel!
    @IBOutlet private var ideaImageView: UIImageView!
    @IBOutlet private var votes: UILabel!
    @IBOutlet private var upvoteButton: UIButton!
    @IBOutlet private var downvoteButton: UIButton!
    
    private var idea: Idea!
    
    func setIdea(_ idea: Idea) {
        self.idea = idea
        name.text = idea.name
        desc.text = idea.description
        ideaImageView.image = idea.mainImage
        Utility.getUserFullName(uid: idea.user, label: user, prefix: Config.ideaUserNamePrefix)
        Utility.updateVotes(idea: idea, votesLabel: votes, upvoteButton: upvoteButton, downvoteButton: downvoteButton)
    }
    
    @IBAction func upvote(_ sender: UIButton) {
        guard System.client.isConnected else {
            UIApplication.shared.keyWindow?.rootViewController?.present(Utility.getNoInternetAlertController(),
                                                                        animated: true, completion: nil)
            return
        }
        idea.upvote()
    }
    
    @IBAction func downvote(_ sender: UIButton) {
        guard System.client.isConnected else {
            UIApplication.shared.keyWindow?.rootViewController?.present(Utility.getNoInternetAlertController(), animated: true, completion: nil)
            return
        }
        idea.downvote()
    }
    
}
