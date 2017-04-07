//
//  IdeaPostTableViewController.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/23/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class IdeaPostTableViewController: ImagePickerTableViewController {
    
    private var currentIdea: Idea?
    
    @IBOutlet private var ideaName: UITextField!
    @IBOutlet private var teamName: UILabel!
    @IBOutlet private var mainImage: UIButton!
    
    private var containerHeight: CGFloat!

    private var ideas = Ideas.sharedInstance()
    private var teams = Teams.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = System.activeUser else {
            return
        }
        cropMode = .square
        teamName.text = "by Team \(teams.retrieveTeamAt(index: user.team).name)"
        preset()
        NotificationCenter.default.addObserver(self, selector: #selector(addIdea), name: Notification.Name(rawValue: "update"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Name(rawValue: "reload"), object: nil)
        hideKeyboardWhenTappedAround()
    }
    
    func setUpIdea(_ idea: Idea) {
        self.currentIdea = idea
    }
    
    private func preset() {
        guard let idea = currentIdea else {
            return
        }
        ideaName.text = idea.name
        mainImage.setImage(idea.mainImage, for: .normal)
    }
    
    @IBAction func changeMainImage(_ sender: UIButton) {
        alertControllerPosition = CGPoint(x: view.frame.width / 2, y: mainImage.bounds.maxY)
        showImageOptions()
    }
    
    override func updateImage(to image: UIImage) {
        mainImage.setImage(image, for: .normal)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Config.image), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "container", let containerViewController = segue.destination as? TemplateEditViewController else {
            return
        }
        if let idea = currentIdea {
            let substring = idea.videoLink.components(separatedBy: "https://www.youtube.com/embed/")
            let videoId = substring.count > 1 ? substring[1] : ""
            containerViewController.presetInfo(desc: idea.description, images: idea.images, videoId: videoId, isScrollEnabled: false)
        }
        containerViewController.tableView.layoutIfNeeded()
        containerHeight = containerViewController.tableView.contentSize.height
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 130
        case 3: return containerHeight
        default: return 44
        }
    }
    
    @objc private func addIdea(_ notification: NSNotification) {
        guard let name = ideaName.text, !name.isEmpty else {
            present(Utility.getFailAlertController(message: "Idea name cannot be empty!"), animated: true, completion: nil)
            return
        }
        guard let description = notification.userInfo?["description"] as? String, let images = notification.userInfo?["images"] as? [UIImage], let videoId = notification.userInfo?["videoId"] as? String, let image = mainImage.image(for: .normal), let user = System.activeUser else {
            return
        }
        NotificationCenter.default.removeObserver(self)
        
        let videoLink = videoId.trimTrailingWhiteSpace().isEmpty ? "" : "https://www.youtube.com/embed/\(videoId)"
        if let idea = currentIdea {
            Ideas.sharedInstance().updateIdea(idea, name: name, description: description, mainImage: image, images: images, videoLink: videoLink)
            return
        }
        ideas.addIdea(idea: Idea(name: name, team: user.team, description: description, mainImage: image, images: images, videoLink: videoLink))
    }
    
    @objc private func reload(_ notification: NSNotification) {
        guard let containerHeight = notification.userInfo?["height"] as? CGFloat else {
            return
        }
        self.containerHeight = containerHeight
        tableView.reloadData()
    }

}
