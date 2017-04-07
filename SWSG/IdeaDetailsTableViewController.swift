//
//  IdeaDetailsTableViewController.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/23/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class IdeaDetailsTableViewController: FullScreenImageTableViewController {
    
    var idea: Idea!
    
    @IBOutlet private var mainImage: UIImageView!
    @IBOutlet private var ideaNameLabel: UILabel!
    @IBOutlet private var teamNameLabel: UILabel!
    @IBOutlet private var votes: UILabel!
    @IBOutlet private var upvoteButton: UIButton!
    @IBOutlet private var downvoteButton: UIButton!
    
    private var containerViewController: TemplateViewController!
    private var containerHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainImage.image = idea.mainImage
        ideaNameLabel.text = idea.name
        teamNameLabel.text = idea.teamName
        updateVotes()
        setNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        containerViewController.presetInfo(desc: idea.description, images: idea.images, videoLink: idea.videoLink, isScrollEnabled: false)
        containerViewController.setUp()
        DispatchQueue.main.async {
            self.containerViewController.tableView.layoutIfNeeded()
            self.containerHeight = self.containerViewController.tableView.contentSize.height
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "container", let containerViewController = segue.destination as? TemplateViewController {
            containerViewController.presetInfo(desc: idea.description, images: idea.images, videoLink: idea.videoLink, isScrollEnabled: false)
            containerViewController.tableView.layoutIfNeeded()
            containerHeight = containerViewController.tableView.contentSize.height
            self.containerViewController = containerViewController
            return
        } else if segue.identifier == "editIdea", let ideaPostTableViewController = segue.destination as? IdeaPostTableViewController {
            ideaPostTableViewController.setUpIdea(idea)
        }
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
    
    private func setNavigationBar() {
        guard let user = System.activeUser, user.team == idea.team else {
            return
        }
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(showDeleteWarning))
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(jumpToEdit))
        navigationItem.rightBarButtonItems = [delete, edit]
    }
    
    @objc private func jumpToEdit() {
        performSegue(withIdentifier: "editIdea", sender: self)
    }
    
    @objc private func showDeleteWarning() {
        let alertController = UIAlertController(title: "Delete Idea", message: "Are you sure to delete this idea?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel)
        alertController.addAction(cancelAction)
        
        let confirmAction = UIAlertAction(title: "Yes", style: .destructive) { action in
            Ideas.sharedInstance().removeIdea(idea: self.idea)
            _ = self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
