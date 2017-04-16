//
//  ImageCropperViewController.swift
//  SWSG
//
//  Created by Shi Xiyue on 19/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class ImageCropperViewController: UIViewController, UIScrollViewDelegate {
    
    var imageToCrop: UIImage!
    
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var cropAreaView: CropAreaView!

    private var offset: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpImage()
        setUpScrollView()
        setUpBorder()
    }
    
    private func setUpImage() {
        imageView.image = imageToCrop
        
        // There's a weired bug. Need to do correction otherwise the image won't be cropped correctly.
        let croppedCgImage = imageView.image?.cgImage?.cropping(to: cropArea)
        guard let cgImage = croppedCgImage else {
            return
        }
        let croppedImage = UIImage(cgImage: cgImage)
        offset = croppedImage.size.width - croppedImage.size.height
    }
    
    private func setUpScrollView() {
        scrollView.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
        setScrollViewZoomScale()
        
        view.sendSubview(toBack: scrollView)
    }
    
    private func setScrollViewZoomScale() {
        scrollView.maximumZoomScale = Config.maximumZoomScale
        let initialScale = imageToCrop.size.height > imageToCrop.size.width ? imageToCrop.size.height / imageToCrop.size.width : imageToCrop.size.width / imageToCrop.size.height
        scrollView.minimumZoomScale = initialScale
        scrollView.zoomScale = initialScale
        
        // The image is not centered vertically at first. Need to calculate the offset to make it center.
        scrollView.contentOffset.y = scrollView.contentSize.height / 2 - imageView.bounds.height / 2
    }

    private func setUpBorder() {
        cropAreaView.layer.borderWidth = 2
        cropAreaView.layer.borderColor = UIColor.white.cgColor
    }
    
    private var cropArea: CGRect {
        guard let image = imageView.image else {
            return CGRect()
        }
        let factor = image.size.width / view.frame.width
        let scale = 1 / scrollView.zoomScale
        let imageFrame = imageView.imageFrame()
        
        let sideLength  = cropAreaView.frame.size.width * scale * factor
        var x = (scrollView.contentOffset.x + cropAreaView.frame.origin.x - imageFrame.origin.x) * scale * factor
        var y = (scrollView.contentOffset.y + cropAreaView.frame.origin.y - imageFrame.origin.y) * scale * factor - offset * scale
        x = x < 0 ? 0 : x + sideLength > imageToCrop.size.width ? imageToCrop.size.width - sideLength : x
        y = y < 0 ? 0 : y + sideLength > imageToCrop.size.height ? imageToCrop.size.height - sideLength : y
        
        return CGRect(x: x, y: y, width: sideLength, height: sideLength)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        self.scrollView.contentSize = CGSize(width: imageView.frame.width * scale,
                                             height: self.imageView.frame.height * scale)
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func choose(_ sender: UIBarButtonItem) {
        let croppedCGImage = imageView.image?.cgImage?.cropping(to:  cropArea)
        var croppedImage = UIImage(cgImage: croppedCGImage!)
        croppedImage = croppedImage.fixOrientation()
    
        let imageDataDict: [String: UIImage] = [Config.image:croppedImage]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Config.image),
                                        object: nil, userInfo: imageDataDict)
        dismiss(animated: false, completion: nil)
    }
    
}
