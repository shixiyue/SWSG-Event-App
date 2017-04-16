//
//  OverviewEditViewController.swift
//  SWSG
//
//  Created by Shi Xiyue on 2/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

/**
 OverviewEditViewController is a UIViewController that allows organizers
 to edit overview content.
 
 Specifications:
 - overview: OverviewContent who will be edited
 */
class OverviewEditViewController: UIViewController {
    
    // MARK: Property
    var overview: OverviewContent!

    func updateOverviewContent(_ notification: NSNotification) {
        guard let description = notification.userInfo?[Config.description] as? String, let images = notification.userInfo?[Config.images] as? [UIImage], let videoId = notification.userInfo?[Config.videoId] as? String else {
            return
        }
        guard !description.isEmptyContent else {
            NotificationCenter.default.post(name: Notification.Name(rawValue: Config.done), object: nil, userInfo: [Config.isSuccess: false])
            present(Utility.getFailAlertController(message: Config.emptyDescriptionError), animated: true, completion: nil)
            return
        }
        
        let videoLink = Utility.getVideoLink(for: videoId)
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
            NotificationCenter.default.post(name: Notification.Name(rawValue: Config.done), object: nil, userInfo: [Config.isSuccess: isSuccess])
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateOverviewContent), name: Notification.Name(rawValue: Config.update), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Config.container, let containerViewController = segue.destination as? TemplateEditViewController else {
            return
        }
        let videoId = Utility.getVideoId(for: overview.videoLink)
        containerViewController.presetInfo(desc: overview.description, images: overview.images, videoId: videoId, isScrollEnabled: true)
    }
    
}
