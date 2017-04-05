//
//  ImagePickerViewController.swift
//  SWSG
//
//  Created by Shi Xiyue on 20/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class ImagePickerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let imagePicker = UIImagePickerController()
    var alertControllerPosition = CGPoint()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    func showImageOptions() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let takePhotoAction = UIAlertAction(title: "Take a photo", style: .default) { action in
            self.takePhoto()
        }
        let selectPhotoAction = UIAlertAction(title: "Select a photo", style: .default) { action in
            self.selectPhoto()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(takePhotoAction)
        alertController.addAction(selectPhotoAction)
        
        alertController.popoverPresentationController?.sourceView = view
        alertController.popoverPresentationController?.sourceRect = CGRect(x: alertControllerPosition.x, y: alertControllerPosition.y, width: 1, height: 1)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func takePhoto() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            present(Utility.getFailAlertController(message: "Sorry, this device has no camera"), animated: true, completion: nil)
            return
        }
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        imagePicker.cameraCaptureMode = .photo
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker,animated: true, completion: nil)
    }
    
    private func selectPhoto() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("test")
        guard let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        dismiss(animated: true, completion: nil)
        handleImage(chosenImage: chosenImage)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateImage(to: UIImage) {
        fatalError("This method must be overridden")
    }
    
}

extension ImagePickerViewController: RSKImageCropViewControllerDelegate {
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        updateImage(to: croppedImage)
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func jumpToCropImage(imageToCrop: UIImage) {
        var imageCropVC : RSKImageCropViewController!
        imageCropVC = RSKImageCropViewController(image: imageToCrop, cropMode: RSKImageCropMode.circle)
        imageCropVC.delegate = self
        self.present(imageCropVC, animated: false, completion: nil)
    }
    
    func handleImage(chosenImage: UIImage) {
        jumpToCropImage(imageToCrop: chosenImage)
    }
    
}

class ImagePickerTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let imagePicker = UIImagePickerController()
    var alertControllerPosition = CGPoint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    func showImageOptions() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let takePhotoAction = UIAlertAction(title: "Take a photo", style: .default) { action in
            self.takePhoto()
        }
        let selectPhotoAction = UIAlertAction(title: "Select a photo", style: .default) { action in
            self.selectPhoto()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(takePhotoAction)
        alertController.addAction(selectPhotoAction)
        
        alertController.popoverPresentationController?.sourceView = view
        alertController.popoverPresentationController?.sourceRect = CGRect(x: alertControllerPosition.x, y: alertControllerPosition.y, width: 1, height: 1)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func takePhoto() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            present(Utility.getFailAlertController(message: "Sorry, this device has no camera"), animated: true, completion: nil)
            return
        }
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        imagePicker.cameraCaptureMode = .photo
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker,animated: true, completion: nil)
    }
    
    private func selectPhoto() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            dismiss(animated: true, completion: nil)
            return
        }
        dismiss(animated: true, completion: nil)
        handleImage(chosenImage: chosenImage)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateImage(to: UIImage) {
        fatalError("This method must be overridden")
    }
    
}

extension ImagePickerTableViewController: RSKImageCropViewControllerDelegate {
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        updateImage(to: croppedImage)
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func jumpToCropImage(imageToCrop: UIImage) {
        var imageCropVC : RSKImageCropViewController!
        imageCropVC = RSKImageCropViewController(image: imageToCrop, cropMode: RSKImageCropMode.circle)
        imageCropVC.delegate = self
        self.present(imageCropVC, animated: false, completion: nil)
    }
    
    func handleImage(chosenImage: UIImage) {
        jumpToCropImage(imageToCrop: chosenImage)
    }
    
}

