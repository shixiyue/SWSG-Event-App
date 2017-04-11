//
//  OverviewViewController.swift
//  SWSG
//
//  Created by Shi Xiyue on 2/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class OverviewViewController: FullScreenImageViewController {
    
    private var containerViewController: TemplateViewController!
    private var overview = OverviewContent() // Placeholder

    override func viewDidLoad() {
        super.viewDidLoad()
        observeOverviewContent()
    }
    
    // TODO: Hide Edit button and disable it before images are fetched
    
    private func observeOverviewContent() {
        let overviewRef = System.client.getOverviewRef()
        overviewRef.observeSingleEvent(of : .value, with : {(snapshot) in
            self.overview = OverviewContent(snapshot: snapshot)
            self.loadContent()
            self.containerViewController.setUp()
            self.loadOverviewImages()
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "container", let containerViewController = segue.destination as? TemplateViewController {
            self.containerViewController = containerViewController
            loadContent()
        } else if segue.identifier == "edit", let editViewController = segue.destination as? OverviewEditViewController {
            editViewController.overview = overview
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadContent()
    }
    
    private func loadContent() {
         containerViewController.presetInfo(desc: overview.description, images: overview.images, videoLink: overview.videoLink, isScrollEnabled: true)
    }
    
    private func loadOverviewImages() {
        guard !overview.imagesState.imagesHasFetched, let id = overview.id else {
            return
        }
        NotificationCenter.default.addObserver(self, selector: #selector(updateImages), name: Notification.Name(rawValue: id), object: nil)
        overview.loadImages()
    }
    
    @objc private func updateImages(_ notification: NSNotification) {
        containerViewController.updateImages(images: overview.images)
        NotificationCenter.default.removeObserver(self)
    }

}

