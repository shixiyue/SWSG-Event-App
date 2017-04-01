//
//  IdeaPostTableViewController.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/23/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class IdeaPostTableViewController: UIViewController {
    
    @IBOutlet private var ideaName: UITextField!
    @IBOutlet private var teamName: UILabel!
    @IBOutlet private var mainImage: UIButton!

    private var ideas = Ideas.sharedInstance()
    private var teams = Teams.sharedInstance()
    
    func addIdea(_ notification: NSNotification) {
        guard let name = ideaName.text, !name.isEmpty else {
            present(Utility.getFailAlertController(message: "Idea name cannot be empty"), animated: true, completion: nil)
            return
        }
        guard let description = notification.userInfo?["description"] as? String, let images = notification.userInfo?["images"] as? [UIImage], let videoId = notification.userInfo?["videoId"] as? String, let image = mainImage.image(for: .normal), let user = System.activeUser else {
            return
        }
        NotificationCenter.default.removeObserver(self)
        
        let videoLink = videoId.trimTrailingWhiteSpace().isEmpty ? "" : "https://www.youtube.com/embed/\(videoId)"
        ideas.addIdea(idea: Idea(name: name, team: teams.retrieveTeamAt(index: user.profile.team).name, description: description, mainImage: image, images: images, videoLink: videoLink))
        print(ideas)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = System.activeUser else {
            return
        }
        teamName.text = "by Team \(teams.retrieveTeamAt(index: user.profile.team).name)"
        NotificationCenter.default.addObserver(self, selector: #selector(addIdea), name: Notification.Name(rawValue: "addIdea"), object: nil)
    }

}
