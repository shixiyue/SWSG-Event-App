//
//  editTemplateTableViewController.swift
//  SWSG
//
//  Created by Shi Xiyue on 28/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

/**
 TemplateEditViewController is a UITableViewController, inherits from UITableViewController.
 
 It provides a template layout to edit/create information.
 */
class TemplateEditViewController: UITableViewController {

    @IBOutlet private var editTemplateTableView: UITableView!
    
    var descriptionTextView: UITextView = UITextView()
    
    private var imagePicker = ImagePickerPopoverViewController()
    private var doneButton: UIButton!
    
    fileprivate let photoIndexOffset = 2
    fileprivate enum Rows: Int {
        case description = 0, addPhoto, videoLink, done, photo
    }
   
    fileprivate var videoLinkTextField: UITextField = UITextField()
    fileprivate var desc: String = Config.emptyString
    fileprivate var images: [UIImage] = []
    fileprivate var videoId: String = Config.emptyString
    
    fileprivate var isScrollEnabled: Bool = false
    fileprivate var isSetDescription = false
    fileprivate var isSetVideoId = false
    
    func presetInfo(desc: String, images: [UIImage], videoId: String, isScrollEnabled: Bool) {
        self.desc = desc
        self.images = images
        self.videoId = videoId
        self.isScrollEnabled = isScrollEnabled
        isSetDescription = false
        isSetVideoId = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTable()
        hideKeyboardWhenTappedAround()
    }
    
    private func setUpTable() {
        editTemplateTableView.allowsSelection = false
        editTemplateTableView.isScrollEnabled = self.isScrollEnabled
        editTemplateTableView.layoutIfNeeded()
    }
    
    @IBAction func addPhoto(_ sender: UIButton) {
        showImagePicker()
    }
    
    private func showImagePicker() {
        Utility.showImagePicker(imagePicker: imagePicker, viewController: self, completion: { (image) in
            guard let image = image else {
                return
            }
            self.images.append(image)
            self.editTemplateTableView.reloadData()
            self.editTemplateTableView.layoutIfNeeded()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Config.reload), object: nil, userInfo: [Config.height: self.editTemplateTableView.contentSize.height])
        })
    }
    
    @IBAction func deleteImage(_ sender: UIButton) {
        guard let superview = sender.superview, let cell = superview.superview as? UITableViewCell, let indexPath = editTemplateTableView.indexPath(for: cell) else {
            return
        }
        
        images.remove(at: indexPath.row - photoIndexOffset)
        editTemplateTableView.reloadData()
        editTemplateTableView.layoutIfNeeded()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Config.reload), object: nil, userInfo: [Config.height: editTemplateTableView.contentSize.height])
    }
    
    @IBAction func update(_ sender: UIButton) {
        guard let description = descriptionTextView.text, let videoId = videoLinkTextField.text else {
            return
        }
        
        doneButton = sender
        doneButton.isEnabled = false
        doneButton.alpha = Config.disableAlpha
        
        let infoDict: [String: Any] = [Config.description: description, Config.images: images, Config.videoId: videoId]
        NotificationCenter.default.addObserver(self, selector: #selector(done), name: Notification.Name(rawValue: Config.done), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Config.update), object: nil, userInfo: infoDict)
    }
    
    @objc private func done(_ notification: NSNotification) {
        doneButton.isEnabled = true
        doneButton.alpha = Config.enableAlpha
        guard let isSuccess = notification.userInfo?[Config.isSuccess] as? Bool, isSuccess else {
            return
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func dismissKeyboard() {
        super.dismissKeyboard()
        view.superview?.superview?.superview?.superview?.endEditing(true)
    }
    
}

extension TemplateEditViewController {
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceIndex = sourceIndexPath.row - photoIndexOffset
        let destinationIndex = destinationIndexPath.row - photoIndexOffset

        let source = images[sourceIndex]
        let destination = images[destinationIndex]
        images[sourceIndex] = destination
        images[destinationIndex] = source
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row >= photoIndexOffset && indexPath.row < photoIndexOffset + images.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Rows.photo.rawValue + images.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case Rows.description.rawValue:
            return getDescriptionTableViewCell(indexPath: indexPath)
        case Rows.addPhoto.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(Rows.addPhoto)", for: indexPath)
            return cell
        case Rows.videoLink.rawValue + images.count:
            return getVideoLinkTableViewCell(indexPath: indexPath)
        case Rows.done.rawValue + images.count:
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(Rows.done)", for: indexPath)
            return cell
        default:
            return getImageTableViewCell(indexPath: indexPath)
        }
    }
    
    private func getDescriptionTableViewCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(Rows.description)", for: indexPath) as? DescriptionTableViewCell else {
            return DescriptionTableViewCell()
        }
        
        if isSetDescription {
            desc = descriptionTextView.text
        }
        isSetDescription = true
        descriptionTextView = cell.descriptionTextView
        descriptionTextView.text = desc
        return cell
    }
    
    private func getVideoLinkTableViewCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(Rows.videoLink)", for: indexPath) as? VideoLinkTableViewCell else {
            return VideoLinkTableViewCell()
        }
        
        if let text = videoLinkTextField.text, isSetVideoId {
            videoId = text
        }
        isSetVideoId = true
        videoLinkTextField = cell.videoLinkTextField
        videoLinkTextField.text = videoId
        return cell
    }
    
    private func getImageTableViewCell(indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row - photoIndexOffset
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(Rows.photo)", for: indexPath) as? PhotoTableViewCell else {
            return PhotoTableViewCell()
        }
        
        cell.photoView.image = images[index]
        return cell
    }
    
}
