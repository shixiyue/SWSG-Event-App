//
//  EditOverviewTableViewController.swift
//  SWSG
//
//  Created by Shi Xiyue on 28/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class TemplateEditViewController: ImagePickerTableViewController {
    
    private let photoIndexOffset = 2
    private enum Rows: Int {
        case description = 0, addPhoto, videoLink, done, photo
    }

    @IBOutlet private var editOverviewTableView: UITableView!
    private var descriptionTextView: UITextView = UITextView()
    private var desc: String = ""
    private var images: [UIImage] = []
    private var videoId: String = ""
    private var videoLinkTextField: UITextField = UITextField()
    private var isScrollEnabled: Bool = false
    private var isSetDescription = false
    private var isSetVideoId = false
    
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
        editOverviewTableView.allowsSelection = false
        hideKeyboardWhenTappedAround()
        editOverviewTableView.isScrollEnabled = self.isScrollEnabled
    }
    
    @IBAction func addPhoto(_ sender: UIButton) {
        showImageOptions()
    }
    
    override func handleImage(chosenImage: UIImage) {
        images.append(chosenImage)
        editOverviewTableView.reloadData()
        editOverviewTableView.layoutIfNeeded()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil, userInfo: ["height": editOverviewTableView.contentSize.height])
    }
    
    @IBAction func deleteImage(_ sender: UIButton) {
        guard let superview = sender.superview, let cell = superview.superview as? UITableViewCell, let indexPath = editOverviewTableView.indexPath(for: cell) else {
            return
        }
        images.remove(at: indexPath.row - photoIndexOffset)
        editOverviewTableView.reloadData()
        editOverviewTableView.layoutIfNeeded()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil, userInfo: ["height": editOverviewTableView.contentSize.height])
    }
    
    @IBAction func update(_ sender: UIButton) {
        guard let description = descriptionTextView.text, let videoId = videoLinkTextField.text else {
            return
        }
        let infoDict: [String: Any] = ["description": description, "images": images, "videoId": videoId]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "update"), object: nil, userInfo: infoDict)
        //OverviewContent.update(description: description, images: images, videoLink: videoLink)
        _ = navigationController?.popViewController(animated: true)
    }
    
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
        case Rows.addPhoto.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(Rows.addPhoto)", for: indexPath)
            return cell
        case Rows.videoLink.rawValue + images.count:
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
        case Rows.done.rawValue + images.count:
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(Rows.done)", for: indexPath)
            return cell
        default:
            let index = indexPath.row - photoIndexOffset
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(Rows.photo)", for: indexPath) as? PhotoTableViewCell else {
                return PhotoTableViewCell()
            }
            cell.photoView.image = images[index]
            return cell
        }
    }
    
}
