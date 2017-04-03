//
//  OverviewEditViewController.swift
//  SWSG
//
//  Created by Shi Xiyue on 2/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class OverviewEditViewController: UIViewController {

    func updateOverviewContent(_ notification: NSNotification) {
        guard let description = notification.userInfo?["description"] as? String, let images = notification.userInfo?["images"] as? [UIImage], let videoId = notification.userInfo?["videoId"] as? String else {
            return
        }
        NotificationCenter.default.removeObserver(self)
        
        let videoLink = videoId.trimTrailingWhiteSpace().isEmpty ? "" : "https://www.youtube.com/embed/\(videoId)"
        OverviewContent.update(description: description, images: images, videoLink: videoLink)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateOverviewContent), name: Notification.Name(rawValue: "update"), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "container", let containerViewController = segue.destination as? TemplateEditViewController else {
            return
        }
        let substring = OverviewContent.videoLink.components(separatedBy: "https://www.youtube.com/embed/")
        let videoId = substring.count > 1 ? substring[1] : ""
        containerViewController.presetInfo(desc: OverviewContent.description, images: OverviewContent.images, videoId: videoId, isScrollEnabled: true)
    }
    
}
