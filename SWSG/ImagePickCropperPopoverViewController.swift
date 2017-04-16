//
//  ImagePickCropperPopoverViewController.swift
//  SWSG
//
//  Created by Shi Xiyue on 9/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class ImagePickCropperPopoverViewController: ImagePickerPopoverViewController {
    
    var cropMode = RSKImageCropMode.circle
    
    override func handleImage(chosenImage: UIImage) {
        jumpToCropImage(imageToCrop: chosenImage)
    }
    
    override func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        dismiss(animated: true, completion: nil)
        dismissController()
    }
    
    override func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        self.image = croppedImage.cropToSquare()
        dismiss(animated: true, completion: nil)
        dismissController()
    }
    
    fileprivate func jumpToCropImage(imageToCrop: UIImage) {
        var imageCropVC : RSKImageCropViewController!
        imageCropVC = RSKImageCropViewController(image: imageToCrop, cropMode: .circle)
        imageCropVC.delegate = self
        self.present(imageCropVC, animated: false, completion: nil)
    }

}

