//
//  IdeaDetailsTableViewController.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/23/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class IdeaDetailsTableViewController: UITableViewController {
    
    var idea: Idea!
    
    @IBOutlet private var mainImage: UIImageView!
    @IBOutlet private var ideaNameLabel: UILabel!
    @IBOutlet private var teamNameLabel: UILabel!
    @IBOutlet private var votes: UILabel!
    @IBOutlet private var upvoteButton: UIButton!
    @IBOutlet private var downvoteButton: UIButton!
    
    private var containerHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainImage.image = idea.mainImage
        ideaNameLabel.text = idea.name
        teamNameLabel.text = idea.teamName
        updateVotes()
        //NotificationCenter.default.addObserver(self, selector: #selector(TeamRegistrationTableViewController.update), name: Notification.Name(rawValue: "commentsForIdeas"), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "container", let containerViewController = segue.destination as? TemplateViewController else {
            return
        }
        containerViewController.presetInfo(desc: idea.description, images: idea.images, videoLink: idea.videoLink, isScrollEnabled: false)
        containerViewController.tableView.layoutIfNeeded()
        containerHeight = containerViewController.tableView.contentSize.height
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 96
        case 3: return containerHeight
        default: return 44
        }
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
