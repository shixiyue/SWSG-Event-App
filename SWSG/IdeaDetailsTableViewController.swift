//
//  IdeaDetailsTableViewController.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/23/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import Firebase

class IdeaDetailsTableViewController: FullScreenImageTableViewController {
    
    fileprivate var containerHeight: CGFloat!
    fileprivate var containerRowIndex = 3
    
    @IBOutlet private var mainImage: UIImageView!
    @IBOutlet private var ideaNameLabel: UILabel!
    @IBOutlet private var userNameLabel: UILabel!
    @IBOutlet private var votes: UILabel!
    @IBOutlet private var upvoteButton: UIButton!
    @IBOutlet private var downvoteButton: UIButton!
    
    private var idea: Idea!
    private var containerViewController: TemplateViewController!
    private var editButton: UIBarButtonItem?
    private var ideaRef: FIRDatabaseReference?
    private var ideaChangeRefHandle: FIRDatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        setUpIdea()
        observeIdeas()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshIdea()
        DispatchQueue.main.async {
            self.containerHeight = self.containerViewController.tableView.contentSize.height
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Config.container, let containerViewController = segue.destination as? TemplateViewController {
            containerViewController.presetInfo(content: idea)
            containerViewController.tableView.layoutIfNeeded()
            containerHeight = containerViewController.tableView.contentSize.height
            self.containerViewController = containerViewController
        } else if segue.identifier == Config.editIdea, let ideaPostTableViewController = segue.destination as? IdeaPostTableViewController {
            ideaPostTableViewController.setIdea(idea)
        } else if segue.identifier == Config.ideaToProfile, let profileVC = segue.destination as? ProfileViewController, let user = sender as? User {
            profileVC.user = user
        }
    }
    
    func setIdea(_ idea: Idea) {
        self.idea = idea
    }
    
    private func setUpNavigationBar() {
        guard let user = System.activeUser, user.uid == idea.user else {
            return
        }
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(showDeleteWarning))
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(jumpToEdit))
        self.editButton = edit
        navigationItem.rightBarButtonItems = [delete, edit]
    }
    
    private func setUpIdea() {
        ideaNameLabel.text = idea.name
        setUpUserName()
        setUpIdeaMainImage()
        loadIdeaImages()
        Utility.updateVotes(idea: idea, votesLabel: votes, upvoteButton: upvoteButton, downvoteButton: downvoteButton)
        
        guard let id = idea.id else {
            return
        }
        ideaRef = System.client.getIdeaRef(for: id).child(Config.votes)
    }
    
    private func setUpUserName() {
        Utility.getUserFullName(uid: idea.user, label: userNameLabel, prefix: Config.ideaUserNamePrefix)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showUserProfile))
        userNameLabel.isUserInteractionEnabled = true
        userNameLabel.addGestureRecognizer(tapGesture)
    }
    
    private func setUpIdeaMainImage() {
        mainImage.image = idea.mainImage
        mainImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showFullScreenImage))
        mainImage.addGestureRecognizer(tapGesture)
    }
    
    private func observeIdeas() {
        guard let ideaRef = ideaRef else {
            return
        }
        
        ideaChangeRefHandle = ideaRef.observe(.value, with: { (snapshot) -> Void in
            DispatchQueue.main.async {
                Utility.updateVotes(idea: self.idea, votesLabel: self.votes, upvoteButton: self.upvoteButton, downvoteButton: self.downvoteButton)
            }
        })
    }
    
    // TODO: Move it to Template
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
    
    private func refreshIdea() {
        mainImage.image = idea.mainImage
        ideaNameLabel.text = idea.name
        containerViewController.setUp()
    }
    
    @IBAction func upvote(_ sender: UIButton) {
        guard System.client.isConnected else {
            present(Utility.getNoInternetAlertController(), animated: true, completion: nil)
            return
        }
        idea.upvote()
    }
    
    @IBAction func downvote(_ sender: UIButton) {
        guard System.client.isConnected else {
            present(Utility.getNoInternetAlertController(), animated: true, completion: nil)
            return
        }
        idea.downvote()
    }
    
    @objc private func updateImages(_ notification: NSNotification) {
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
    
    @objc private func showUserProfile() {
        System.client.getUserWith(uid: idea.user, completion: { (user, error) in
            guard let user = user else {
                return
            }
            self.performSegue(withIdentifier: Config.ideaToProfile, sender: user)
        })
    }
    
    @objc private func jumpToEdit() {
        performSegue(withIdentifier: Config.editIdea, sender: self)
    }
    
    @objc private func showDeleteWarning() {
        let alertController = UIAlertController(title: Config.deleteIdea, message: Config.deleteIdeaWarning, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: Config.no, style: .cancel)
        alertController.addAction(cancelAction)
        
        let confirmAction = UIAlertAction(title: Config.yes, style: .destructive) { action in
            self.deleteIdea()
        }
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func deleteIdea() {
        guard System.client.isConnected else {
            present(Utility.getNoInternetAlertController(), animated: true, completion: nil)
            return
        }
        Ideas.sharedInstance().removeIdea(idea: self.idea, completion: { (error) in
            if let error = error {
                self.present(Utility.getFailAlertController(message: error.errorMessage), animated: true, completion: nil)
                return
            }
            _ = self.navigationController?.popViewController(animated: true)
        })
    }
    
    deinit {
        if let changeHandle = ideaChangeRefHandle {
            ideaRef?.removeObserver(withHandle: changeHandle)
        }
    }
    
}

extension IdeaDetailsTableViewController {
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == containerRowIndex {
            return containerHeight
        }
        return UITableViewAutomaticDimension
    }
    
}
