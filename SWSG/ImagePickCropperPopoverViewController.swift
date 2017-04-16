//
//  ImagePickCropperPopoverViewController.swift
//  SWSG
//
//  Created by Shi Xiyue on 9/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

/**
 ImagePickCropperPopoverViewController is a ImagePickerViewController. 
 It supprots user to crop a selected image.
 */
class ImagePickCropperPopoverViewController: ImagePickerPopoverViewController {
    
    var cropMode = RSKImageCropMode.circle
    
    override func handleImage(chosenImage: UIImage) {
        jumpToCropImage(imageToCrop: chosenImage)
    }

}

extension ImagePickCropperPopoverViewController: RSKImageCropViewControllerDelegate {
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        dismiss(animated: true, completion: nil)
        dismissController()
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController,
                                 didCropImage croppedImage: UIImage,
                                 usingCropRect cropRect: CGRect) {
        self.image = croppedImage.cropToSquare()
        dismiss(animated: true, completion: nil)
        dismissController()
    }
    
    fileprivate func jumpToCropImage(imageToCrop: UIImage) {
        let imageCropVC = RSKImageCropViewController(image: imageToCrop, cropMode: cropMode)
        imageCropVC.delegate = self
        self.present(imageCropVC, animated: false, completion: nil)
    }
    
}
