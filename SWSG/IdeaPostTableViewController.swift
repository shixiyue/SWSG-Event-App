//
//  IdeaPostTableViewController.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/23/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class IdeaPostTableViewController: UITableViewController {
    
    private var currentIdea: Idea?
    
    @IBOutlet fileprivate var ideaName: UITextField!
    @IBOutlet private var userName: UILabel!
    @IBOutlet private var mainImage: UIButton!
    
    fileprivate var containerHeight: CGFloat!
    fileprivate var containerRowIndex = 3
    fileprivate var containerViewController: TemplateEditViewController!
    fileprivate var textView: UITextView!
    
    private var ideas = Ideas.sharedInstance()
    private var imagePicker = ImagePickCropperPopoverViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpIdea()
        setUpNotifications()
        hideKeyboardWhenTappedAround()
    }
    
    func setIdea(_ idea: Idea) {
        self.currentIdea = idea
    }
    
    private func setUpIdea() {
        guard let user = System.activeUser else {
            return
        }
        userName.text = Config.ideaUserNamePrefix + user.profile.name
        guard let idea = currentIdea else {
            return
        }
        ideaName.text = idea.name
        ideaName.becomeFirstResponder()
        ideaName.delegate = self
        mainImage.setImage(idea.mainImage, for: .normal)
    }
    
    private func setUpNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(donePressed), name: Notification.Name(rawValue: Config.update), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Name(rawValue: Config.reload), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Config.container, let containerViewController = segue.destination as? TemplateEditViewController else {
            return
        }
        if let idea = currentIdea {
            let videoId = Utility.getVideoId(for: idea.videoLink)
            containerViewController.presetInfo(desc: idea.description, images: idea.images, videoId: videoId, isScrollEnabled: false)
        }
        containerHeight = containerViewController.tableView.contentSize.height
        self.containerViewController = containerViewController
        textView = containerViewController.descriptionTextView
    }
    
    @IBAction func changeMainImage(_ sender: UIButton) {
        showImagePicker()
    }
    
    private func showImagePicker() {
        imagePicker.cropMode = .square
        Utility.showImagePicker(imagePicker: imagePicker, viewController: self, completion: { (image) in
            if let image = image {
                self.mainImage.setImage(image, for: .normal)
            }
            self.ideaName.becomeFirstResponder()
        })
    }
    
    @objc private func reload(_ notification: NSNotification) {
        guard let containerHeight = notification.userInfo?[Config.height] as? CGFloat else {
            return
        }
        self.containerHeight = containerHeight
        textView = containerViewController.descriptionTextView
        
        tableView.reloadData()
    }
    
    @objc private func donePressed(_ notification: NSNotification) {
        guard System.client.isConnected else {
            present(Utility.getNoInternetAlertController(), animated: true, completion: nil)
            return
        }
        guard let name = ideaName.text, !name.isEmptyContent else {
            NotificationCenter.default.post(name: Notification.Name(rawValue: Config.done), object: nil, userInfo: [Config.isSuccess: false])
            present(Utility.getFailAlertController(message: Config.emptyIdeaNameError), animated: true, completion: nil)
            return
        }
        guard let description = notification.userInfo?[Config.description] as? String, !description.isEmptyContent else {
            NotificationCenter.default.post(name: Notification.Name(rawValue: Config.done), object: nil, userInfo: [Config.isSuccess: false])
            present(Utility.getFailAlertController(message: Config.emptyDescriptionError), animated: true, completion: nil)
            return
        }
        guard let images = notification.userInfo?[Config.images] as? [UIImage], let videoId = notification.userInfo?[Config.videoId] as? String, let mainImage = mainImage.image(for: .normal) else {
            present(Utility.getFailAlertController(message: Config.generalErrorMessage), animated: true, completion: nil)
            return
        }
        let videoLink = Utility.getVideoLink(for: videoId)
        if let idea = currentIdea {
            updateIdea(idea: idea, name: name, description: description, mainImage: mainImage, images: images, videoLink: videoLink)
            return
        }
        createIdea(name: name, description: description, mainImage: mainImage, images: images, videoLink: videoLink)
    }
    
    private func updateIdea(idea: Idea, name: String, description: String, mainImage: UIImage, images: [UIImage], videoLink: String) {
        let updatedIdea = idea.getUpdatedIdea(name: name, description: description, mainImage: mainImage, images: images, videoLink: videoLink)
        System.client.updateIdeaContent(for: updatedIdea, completion: { (error) in
            if error == nil {
                idea.update(name: name, description: description, mainImage: mainImage, images: images, videoLink: videoLink)
            }
            self.getResult(error: error)
        })
    }
    
    private func createIdea(name: String, description: String, mainImage: UIImage, images: [UIImage], videoLink: String) {
        guard let user = System.activeUser, let uid = user.uid else {
            present(Utility.getFailAlertController(message: Config.generalErrorMessage), animated: true, completion: nil)
            return
        }
        let idea = Idea(name: name, user: uid, description: description, mainImage: mainImage, images: images, videoLink: videoLink)
        System.client.createIdea(idea: idea, completion: { (error) in
            self.getResult(error: error)
        })
    }
    
    private func getResult(error: FirebaseError?) {
        var isSuccess: Bool
        if let firebaseError = error {
            present(Utility.getFailAlertController(message: firebaseError.errorMessage), animated: true, completion: nil)
            isSuccess = false
        } else {
            NotificationCenter.default.removeObserver(self)
            isSuccess = true
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: Config.done), object: nil, userInfo: [Config.isSuccess: isSuccess])
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

extension IdeaPostTableViewController {
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == containerRowIndex {
            return containerHeight
        }
        return UITableViewAutomaticDimension
    }
    
}

extension IdeaPostTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textView.becomeFirstResponder()
        return false
    }
}
