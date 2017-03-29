//
//  EditOverviewTableViewController.swift
//  SWSG
//
//  Created by Shi Xiyue on 28/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class EditOverviewTableViewController: ImagePickerViewController {
    
    private let photoIndexOffset = 2
    private enum Rows: Int {
        case description = 0, addPhoto, videoLink, done, photo
    }

    @IBOutlet private var editOverviewTableView: UITableView!
    private var descriptionTextView: UITextView!
    private var (eventDescription, videoLink, photos) = (OverviewContent.description, OverviewContent.videoLink, OverviewContent.photos) // Need to fetch data from database
    private var videoLinkTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editOverviewTableView.allowsSelection = false
    }

    @IBAction func addPhoto(_ sender: UIButton) {
        showImageOptions()
    }
    
    override func handleImage(chosenImage: UIImage) {
        photos.append(chosenImage)
        editOverviewTableView.reloadData()
    }
    
    @IBAction func deleteImage(_ sender: UIButton) {
        guard let superview = sender.superview, let cell = superview.superview as? UITableViewCell, let indexPath = editOverviewTableView.indexPath(for: cell) else {
            return
        }
        photos.remove(at: indexPath.row - photoIndexOffset)
        editOverviewTableView.reloadData()
    }
    
    @IBAction func update(_ sender: RoundCornerButton) {
        guard let description = descriptionTextView.text, let videoLink = videoLinkTextField.text else {
            return
        }
        OverviewContent.update(description: description, photos: photos, videoLink: videoLink)
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceIndex = sourceIndexPath.row - photoIndexOffset
        let destinationIndex = destinationIndexPath.row - photoIndexOffset
        let source = photos[sourceIndex]
        let destination = photos[destinationIndex]
        photos[sourceIndex] = destination
        photos[destinationIndex] = source
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row >= photoIndexOffset && indexPath.row < photoIndexOffset + photos.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Rows.photo.rawValue + photos.count
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
            descriptionTextView = cell.descriptionTextView
            descriptionTextView.text = eventDescription
            return cell
        case Rows.addPhoto.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(Rows.addPhoto)", for: indexPath)
            return cell
        case Rows.videoLink.rawValue + photos.count:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(Rows.videoLink)", for: indexPath) as? VideoLinkTableViewCell else {
                return VideoLinkTableViewCell()
            }
            videoLinkTextField = cell.videoLinkTextField
            videoLinkTextField.text = videoLink
            return cell
        case Rows.done.rawValue + photos.count:
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(Rows.done)", for: indexPath)
            return cell
        default:
            let index = indexPath.row - photoIndexOffset
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(Rows.photo)", for: indexPath) as? PhotoTableViewCell else {
                return PhotoTableViewCell()
            }
            cell.photoView.image = photos[index]
            return cell
        }
    }
    
}
