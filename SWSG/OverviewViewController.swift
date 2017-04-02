//
//  OverviewViewController.swift
//  SWSG
//
//  Created by Shi Xiyue on 2/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class OverviewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "container", let containerViewController = segue.destination as? TemplateViewController else {
            return
        }
        containerViewController.presetInfo(desc: OverviewContent.description, images: OverviewContent.images, videoLink: OverviewContent.videoLink, isScrollEnabled: true)
    }

}
