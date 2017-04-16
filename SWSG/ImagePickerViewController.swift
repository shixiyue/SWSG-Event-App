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
    var alertControllerPosition: CGPoint!

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        alertControllerPosition =  CGPoint(x: view.frame.width / 2, y: view.frame.height)
    }
    
    func showImageOptions() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: Config.cancel, style: .cancel)
        let takePhotoAction = UIAlertAction(title: Config.takePhoto, style: .default) { action in
            self.takePhoto()
        }
        let selectPhotoAction = UIAlertAction(title: Config.selectPhoto, style: .default) { action in
            self.selectPhoto()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(takePhotoAction)
        alertController.addAction(selectPhotoAction)
        
        alertController.popoverPresentationController?.sourceView = view
        alertController.popoverPresentationController?.sourceRect = CGRect(x: alertControllerPosition.x, y: alertControllerPosition.y, width: Config.defaultValue, height: Config.defaultValue)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func takePhoto() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            present(Utility.getFailAlertController(message: Config.noCamera), animated: true, completion: nil)
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
    
    func handleImage(chosenImage: UIImage) {
        fatalError(Config.needOverriden)
    }

}
