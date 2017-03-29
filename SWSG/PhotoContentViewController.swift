//
//  PhotoContentViewController.swift
//  SWSG
//
//  Created by Shi Xiyue on 25/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class PhotoContentViewController: UIViewController {
    
    @IBOutlet private var imageView: UIImageView!
    var photoIndex: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = OverviewContent.photos[photoIndex]
    }

}
