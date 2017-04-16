//
//  PhotoContentViewController.swift
//  SWSG
//
//  Created by Shi Xiyue on 25/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

/**
 PhotoContentViewController is a UIViewController.
 
 It is a page in PhotoPageViewController and contain a photo
 */
class PhotoContentViewController: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet private var imageView: UIImageView!
    
    // MARK: Property
    private var image: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpImageView()
    }
    
    private func setUpImageView() {
        imageView.image = image
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showFullScreenImage))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    func setImage(_ image: UIImage) {
        self.image = image
    }
    
    @objc private func showFullScreenImage() {
        let imageDataDict: [String: UIImage] = [Config.fullScreenImage: image]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Config.fullScreenImage), object: nil, userInfo: imageDataDict)
    }

}
