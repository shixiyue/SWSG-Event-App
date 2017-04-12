//
//  OverviewEditViewController.swift
//  SWSG
//
//  Created by Shi Xiyue on 2/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class OverviewEditViewController: UIViewController {
    
    var overview: OverviewContent!

    func updateOverviewContent(_ notification: NSNotification) {
        guard let description = notification.userInfo?["description"] as? String, let images = notification.userInfo?["images"] as? [UIImage], let videoId = notification.userInfo?["videoId"] as? String else {
            return
        }
        
        let videoLink = videoId.trimTrailingWhiteSpace().isEmpty ? "" : "https://www.youtube.com/embed/\(videoId)"
        let updatedOverview = overview.getUpdatedOverview(description: description, images: images, videoLink: videoLink)
        System.client.updateInformation(overview: updatedOverview, completion: { (error) in
            var isSuccess: Bool
            if let error = error {
                self.present(Utility.getFailAlertController(message: error.errorMessage), animated: true, completion: nil)
                isSuccess = false
            } else {
                self.overview.update(description: description, images: images, videoLink: videoLink)
                NotificationCenter.default.removeObserver(self)
                isSuccess = true
            }
            NotificationCenter.default.post(name: Notification.Name(rawValue: "done"), object: nil, userInfo: ["isSuccess": isSuccess])
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateOverviewContent), name: Notification.Name(rawValue: "update"), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "container", let containerViewController = segue.destination as? TemplateEditViewController else {
            return
        }
        let substring = overview.videoLink.components(separatedBy: "https://www.youtube.com/embed/")
        let videoId = substring.count > 1 ? substring[1] : ""
        containerViewController.presetInfo(desc: overview.description, images: overview.images, videoId: videoId, isScrollEnabled: true)
    }
    
}
