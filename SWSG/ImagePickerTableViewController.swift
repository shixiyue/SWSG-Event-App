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
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(takePhotoAction)
        }
        
        alertController.addAction(selectPhotoAction)
        
        alertController.popoverPresentationController?.sourceView = view
        alertController.popoverPresentationController?.sourceRect = CGRect(x: alertControllerPosition.x, y: alertControllerPosition.y, width: 1, height: 1)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func takePhoto() {
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
    
    func handleImage(chosenImage: UIImage) {
        jumpToCropImage(imageToCrop: chosenImage)
    }
    
    private func jumpToCropImage(imageToCrop: UIImage) {
        NotificationCenter.default.addObserver(self, selector: #selector(updateImage), name: NSNotification.Name(rawValue: Config.image), object: nil)
        
        let storyboard = UIStoryboard(name: Config.uiSupporting, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: Config.imageCropperViewController) as! ImageCropperViewController
        controller.imageToCrop = imageToCrop
        present(controller, animated: false, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateImage(_ notification: NSNotification) {
        fatalError("This method must be overridden")
    }
    
}
