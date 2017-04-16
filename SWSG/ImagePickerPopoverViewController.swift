//
//  ImagePickerPopoverViewController.swift
//  SWSG
//
//  Created by Jeremy Jee on 6/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class ImagePickerPopoverViewController: ImagePickerViewController {
    
    var image: UIImage?
    var completionHandler : ((_ image: UIImage?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        view.addGestureRecognizer(tap)
    }
    
    override func handleImage(chosenImage: UIImage) {
        self.image = chosenImage
        dismissController()
    }
    
    func dismissController() {
        self.dismiss(animated: true) {
            self.completionHandler?(self.image)
        }
    }
}
