//
//  ProfileViewController.swift
//  SWSG
//
//  Created by shixiyue on 17/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    @IBOutlet private var profileImgButton: UIButton!
    @IBOutlet private var nameLbl: UILabel!
    @IBOutlet private var teamLbl: UILabel!
    @IBOutlet var profileList: UITableView!

    private let imagePicker = UIImagePickerController()



    override func viewDidLoad() {
        super.viewDidLoad()
    
        setUpProfileList()
        imagePicker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        profileList.reloadData()
        setUpUserInfo()
    }
    
    private func setUpProfileList() {
        profileList.tableFooterView = UIView(frame: CGRect.zero)
        profileList.allowsSelection = false
    }
    
    private func setUpUserInfo() {
        guard let user = System.activeUser else {
            Utility.logOutUser(currentViewController: self)
            return
        }
        
        profileImgButton.setImage(user.profile.image, for: .normal)
        profileImgButton.addTarget(self, action: #selector(showProfileImageOptions), for: .touchUpInside)
        
        nameLbl.text = user.profile.name
        
        guard let participant = user as? Participant else {
            teamLbl.text = nil
            return
        }
        if participant.team != -1 {
            teamLbl.text = Teams.sharedInstance().retrieveTeamAt(index: participant.team).name
        } else {
            teamLbl.text = Config.noTeamLabel
        }
    }

    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    // Cannot get those methods by inheriting ImagePickerViewController, because ImageViewController is a UITableViewController, a requirement of SignUpTableViewController and EditProfileTableViewController (because Swift does not support multi-inheritance), but ProfileViewController cannot be a tableview controller.
    @objc private func showProfileImageOptions() {
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
        alertController.popoverPresentationController?.sourceRect = CGRect(x: view.frame.width / 2, y: profileImgButton.bounds.maxY, width: 1, height: 1)
        
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
        jumpToCropImage(imageToCrop: chosenImage)
    }
    
    private func jumpToCropImage(imageToCrop: UIImage) {
        NotificationCenter.default.addObserver(self, selector: #selector(updateImage), name: NSNotification.Name(rawValue: Config.image), object: nil)
        
        let storyboard = UIStoryboard(name: Config.imageCropper, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: Config.imageCropperViewController) as! ImageCropperViewController
        controller.imageToCrop = imageToCrop
        present(controller, animated: false, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateImage(_ notification: NSNotification) {
        guard let image = notification.userInfo?[Config.image] as? UIImage else {
            return
        }
        
        guard let user = System.activeUser else {
            Utility.logOutUser(currentViewController: self)
            return
        }
        user.profile.updateImage(image: image)
        System.updateActiveUser()
        
        NotificationCenter.default.removeObserver(self)
    }

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.item
        let (field, content) = ProfileItems.items[index]
        
        guard let cell = profileList.dequeueReusableCell(withIdentifier: Config.profileCell, for: indexPath) as? ProfileTableViewCell else {
            return ProfileTableViewCell()
        }
        
        cell.field.text = field
        cell.content.text = content
        return cell
    }
    
}
