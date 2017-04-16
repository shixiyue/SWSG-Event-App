//
//  SponsorsTableViewCell.swift
//  SWSG
//
//  Created by Shi Xiyue on 27/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class SponsorsTableViewCell: UITableViewCell {

    @IBOutlet private var firstImage: UIImageView!
    @IBOutlet private var secondImage: UIImageView!
    @IBOutlet private var thirdImage: UIImageView!
    
    func setFirst(image: UIImage, link: String) {
        firstImage.image = image
        firstLink = link
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openFirstLink))
        firstImage.addGestureRecognizer(tapGestureRecognizer)
        firstImage.isUserInteractionEnabled = true
    }
    
    func setSecond(image: UIImage, link: String) {
        secondImage.image = image
        secondLink = link
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openSecondLink))
        secondImage.addGestureRecognizer(tapGestureRecognizer)
        secondImage.isUserInteractionEnabled = true
    }
    
    func setThird(image: UIImage, link: String) {
        thirdImage.image = image
        thirdLink = link
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openThirdLink))
        thirdImage.addGestureRecognizer(tapGestureRecognizer)
        thirdImage.isUserInteractionEnabled = true
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
        UIApplication.shared.open(url)
    }
    
}
