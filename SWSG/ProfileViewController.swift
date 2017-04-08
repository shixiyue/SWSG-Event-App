//
//  ProfileViewController.swift
//  SWSG
//
//  Created by shixiyue on 17/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class ProfileViewController: ImagePickerViewController, UIGestureRecognizerDelegate {

    @IBOutlet private var profileImgButton: UIButton!
    @IBOutlet private var nameLbl: UILabel!
    @IBOutlet private var usernameLbl: UILabel!
    @IBOutlet private var teamLbl: UILabel!
    @IBOutlet fileprivate var profileList: UITableView!
    @IBOutlet private var changeProfileImageToolbar: UIToolbar!
    
    private var fullScreenImageView: UIImageView!

    private let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        setUpProfileList()
        imagePicker.delegate = self
        changeProfileImageToolbar.isHidden = true
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
        profileImgButton.addTarget(self, action: #selector(showFullScreenImage), for: .touchUpInside)
        
        nameLbl.text = user.profile.name
        usernameLbl.text = "@\(user.profile.username)"
        
        guard user.type.isParticipant else {
            teamLbl.text = user.type.toString()
            return
        }
        if user.team != -1 {
            teamLbl.text = Teams.sharedInstance().retrieveTeamAt(index: user.team).name
        } else {
            teamLbl.text = Config.noTeamLabel
        }
    }

    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    override func updateImage(to image: UIImage) {
        guard let user = System.activeUser else {
            Utility.logOutUser(currentViewController: self)
            return
        }
        fullScreenImageView.image = image.cropSquareToCircle()
        user.profile.updateImage(image: image)
        // Error handling?
        System.client.updateUser(newUser: user)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func showFullScreenImage() {
        guard let image = profileImgButton.imageView?.image else {
            return
        }
        fullScreenImageView = UIImageView(image: image.cropSquareToCircle())
        fullScreenImageView.frame = self.view.frame
        fullScreenImageView.backgroundColor = .black
        fullScreenImageView.contentMode = .scaleAspectFit
        fullScreenImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullScreenImage))
        tap.delegate = self
        fullScreenImageView.addGestureRecognizer(tap)
        self.view.addSubview(fullScreenImageView)
        changeProfileImageToolbar.isHidden = false
        view.bringSubview(toFront: changeProfileImageToolbar)
    }
    
    @objc private func dismissFullScreenImage(sender: UITapGestureRecognizer) {
        guard sender.state == .ended else {
            return
        }
        changeProfileImageToolbar.isHidden = true
        sender.view?.removeFromSuperview()
    }

    @IBAction func changeProfileImage(_ sender: UIBarButtonItem) {
        showImageOptions()
        alertControllerPosition = CGPoint(x: view.frame.width / 2, y: profileImgButton.bounds.maxY)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
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
