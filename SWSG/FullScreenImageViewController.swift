//
//  FullScreenImageViewController.swift
//  SWSG
//
//  Created by Shi Xiyue on 6/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class FullScreenImageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(showFullScreenImage as (NSNotification) -> Void), name: Notification.Name(rawValue: Config.fullScreenImage), object: nil)
    }
    
    func showFullScreenImage(sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView, let image = imageView.image else {
            return
        }
        showFullScreenImage(image: image)
    }
    
    @objc private func showFullScreenImage(_ notification: NSNotification) {
        guard let image = notification.userInfo?[Config.fullScreenImage] as? UIImage else {
            return
        }
        showFullScreenImage(image: image)
    }
    
    private func showFullScreenImage(image: UIImage) {
        let newImageView = UIImageView(image: image)
        newImageView.frame = self.view.frame
        newImageView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
    }
    
    @objc private func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

class FullScreenImageTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(showFullScreenImage as (NSNotification) -> Void), name: Notification.Name(rawValue: Config.fullScreenImage), object: nil)
    }
    
    func showFullScreenImage(sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView, let image = imageView.image else {
            return
        }
        showFullScreenImage(image: image)
    }
    
    @objc private func showFullScreenImage(_ notification: NSNotification) {
        guard let image = notification.userInfo?[Config.fullScreenImage] as? UIImage else {
            return
        }
        showFullScreenImage(image: image)
    }
    
    private func showFullScreenImage(image: UIImage) {
        let newImageView = UIImageView(image: image)
        newImageView.frame = self.view.frame
        if let height = self.navigationController?.navigationBar.frame.size.height {
            newImageView.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y - height, width: self.view.frame.width, height: self.view.frame.height)
        } else {
            newImageView.frame = self.view.frame
        }
        newImageView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
    }
    
    @objc private func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
