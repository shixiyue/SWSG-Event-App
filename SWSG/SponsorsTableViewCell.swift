//
//  SponsorsTableViewCell.swift
//  SWSG
//
//  Created by Shi Xiyue on 27/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class SponsorsTableViewCell: UITableViewCell {

    @IBOutlet var firstImage: UIImageView!
    @IBOutlet var secondImage: UIImageView!
    @IBOutlet var thirdImage: UIImageView!
    
    var firstLink: String! {
        didSet {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openFirstLink))
            firstImage.addGestureRecognizer(tapGestureRecognizer)
            firstImage.isUserInteractionEnabled = true
        }
    }
    var secondLink: String! {
        didSet {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openSecondLink))
            secondImage.addGestureRecognizer(tapGestureRecognizer)
            secondImage.isUserInteractionEnabled = true
        }
    }
    var thirdLink: String! {
        didSet {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openThirdLink))
            thirdImage.addGestureRecognizer(tapGestureRecognizer)
            thirdImage.isUserInteractionEnabled = true
        }
    }
    
    @objc private func openFirstLink(gesture: UITapGestureRecognizer) {
        openLink(firstLink)
    }
    
    @objc private func openSecondLink(gesture: UITapGestureRecognizer) {
        openLink(secondLink)
    }
    
    @objc private func openThirdLink(gesture: UITapGestureRecognizer) {
        openLink(thirdLink)
    }
    
    private func openLink(_ link: String) {
        guard let url = URL(string: link) else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
}
