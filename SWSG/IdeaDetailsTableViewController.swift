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
    private var editButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setUpIdea()
    }
    
    private func setUpIdea() {
        loadIdeaImages()
        setUpIdeaMainImage()
        ideaNameLabel.text = idea.name
        updateVotes()
        Utility.getTeamName(id: idea.team, label: teamNameLabel, prefix: "by Team ")
    }
    
    private func loadIdeaImages() {
        guard !idea.imagesState.imagesHasFetched, let id = idea.id else {
            return
        }
        if let edit = editButton {
            edit.isEnabled = false
        }
        NotificationCenter.default.addObserver(self, selector: #selector(updateImages), name: Notification.Name(rawValue: id), object: nil)
        idea.loadImages()
    }
    
    private func setUpIdeaMainImage() {
        mainImage.image = idea.mainImage
        mainImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showFullScreenImage))
        mainImage.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainImage.image = idea.mainImage
        ideaNameLabel.text = idea.name
        containerViewController.setUp()
        DispatchQueue.main.async {
            self.containerViewController.tableView.layoutIfNeeded()
            self.containerHeight = self.containerViewController.tableView.contentSize.height
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "container", let containerViewController = segue.destination as? TemplateViewController {
            containerViewController.presetInfo(content: idea)
            containerViewController.tableView.layoutIfNeeded()
            containerHeight = containerViewController.tableView.contentSize.height
            self.containerViewController = containerViewController
            return
        } else if segue.identifier == "editIdea", let ideaPostTableViewController = segue.destination as? IdeaPostTableViewController {
            ideaPostTableViewController.setUpIdea(idea)
        }
    }
    
    @objc func updateImages(_ notification: NSNotification) {
        mainImage.image = idea.mainImage
        containerViewController.updateImages()
        DispatchQueue.main.async {
            self.containerViewController.tableView.layoutIfNeeded()
            self.containerHeight = self.containerViewController.tableView.contentSize.height
            self.tableView.reloadData()
        }
        if let edit = editButton {
            edit.isEnabled = true
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
        guard System.client.isConnected else {
            present(Utility.getNoInternetAlertController(), animated: true, completion: nil)
            return
        }
        idea.upvote()
        updateVotes()
    }
    
    @IBAction func downvote(_ sender: UIButton) {
        guard System.client.isConnected else {
            present(Utility.getNoInternetAlertController(), animated: true, completion: nil)
            return
        }
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
        self.editButton = edit
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
