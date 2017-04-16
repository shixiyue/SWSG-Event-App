//
//  ProfileViewController.swift
//  SWSG
//
//  Created by shixiyue on 17/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    var user: User?

    @IBOutlet fileprivate var profileList: UITableView!
    @IBOutlet private var profileImgButton: UIButton!
    @IBOutlet private var nameLbl: UILabel!
    @IBOutlet private var usernameLbl: UILabel!
    @IBOutlet private var teamLbl: UILabel!
    @IBOutlet private var changeProfileImageToolbar: UIToolbar!
    
    @IBOutlet private var composeBtn: UIImageView!
    @IBOutlet private var topRightBtn: UIBarButtonItem!
    
    fileprivate var profileItems: [(String, String)]?
    
    private var isActiveUser: Bool = false
    private var isFavourite = false
    private var fullScreenImageView: UIImageView!
    private let imagePicker = ImagePickCropperPopoverViewController()
    
    private var userRef: FIRDatabaseReference?
    private var userExistingHandle: FIRDatabaseHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeUser()
        setUpProfileList()
        setUpProfileImage()
        setUpTopRightBtn()
        setUpChatButton() 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        profileList.reloadData()
        setUpUserInfo()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == Config.profileToChannel, let channel = sender as? Channel else {
            return
        }
        guard let chatVc = segue.destination as? ChannelViewController else {
            return
        }
            
        chatVc.senderDisplayName = System.activeUser?.profile.username
        chatVc.channel = channel
    }
    
    // MARK: Firebase related methods
    private func observeUser() {
        guard let uid = user?.uid else {
            return
        }
        
        userRef = System.client.getUserRef(for: uid)
        userExistingHandle = userRef?.observe(.value, with: { (snapshot) in
            guard let user = User(uid: uid, snapshot: snapshot) else {
                return
            }
            
            self.user = user
            self.setUpUserInfo()
            self.profileList.reloadData()
            
            Utility.getProfileImg(uid: uid, completion: { (image) in
                if let image = image {
                    self.profileImgButton.setImage(image, for: .normal)
                }
            })
        })
    }
    
    private func setUpProfileList() {
        profileList.tableFooterView = UIView(frame: CGRect.zero)
        profileList.allowsSelection = false
    }
    
    private func setUpProfileImage() {
        profileImgButton.setImage(Config.placeholderImg, for: .normal)
        changeProfileImageToolbar.isHidden = true
    }
    
    private func setUpTopRightBtn() {
        guard let user = user, let activeUser = System.activeUser,
            let uid = user.uid, let activeUID = activeUser.uid else {
                isActiveUser = false
                return
        }
        
        if uid == activeUID {
            isActiveUser = true
            return
        }
        
        let button = UIButton(type: .system)
        if let favourites = activeUser.favourites, favourites.contains(uid) {
            button.setImage(Config.fullStar, for: .normal)
            isFavourite = true
        } else {
            button.setImage(Config.emptyStar, for: .normal)
        }
        
        button.addTarget(self, action: #selector(topRightBtnPressed), for: .touchUpInside)
        button.sizeToFit()
        
        topRightBtn.customView = button
    }
    
    private func setUpChatButton() {
        guard !isActiveUser else {
            return
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(composeBtnPressed))
        composeBtn.addGestureRecognizer(tapGesture)
        composeBtn.isHidden = false
    }
    
    private func setUpUserInfo() {
        guard let user = user else {
            return
        }
        
        profileItems = ProfileItems.getItems(user: user)
        
        if let image = user.profile.image {
            profileImgButton.setImage(image, for: .normal)
        }
        profileImgButton.addTarget(self, action: #selector(showFullScreenImage), for: .touchUpInside)
        
        nameLbl.text = user.profile.name
        usernameLbl.text = "@\(user.profile.username)"
        
        Utility.getTeamLbl(user: user, completion: { (teamLblText) in
            self.teamLbl.text = teamLblText
        })
    }
    
    @objc private func composeBtnPressed(_ sender: UITapGestureRecognizer) {
        guard let currentUID = System.client.getUid(), let user = user, let userUID = user.uid else {
            return
        }
        
        var members = [String]()
        members.append(currentUID)
        members.append(userUID)
        
        let channel = Channel(type: .directMessage, members: members)
        System.client.createChannel(for: channel, completion: { (channel, error) in
            guard error == nil else {
                return
            }
            self.performSegue(withIdentifier: Config.profileToChannel, sender: channel)
        })
    }
    
    @IBAction func topRightBtnPressed(_ sender: Any) {
        guard let user = user, let uid = user.uid else {
            return
        }
        
        if isActiveUser {
            performSegue(withIdentifier: Config.profileToEditProfile, sender: nil)
            return
        }
        
        let button = UIButton(type: .system)
        if isFavourite {
            System.client.removeFavourte(uid: uid)
            button.setImage(Config.emptyStar, for: .normal)
            isFavourite = false
        } else {
            System.client.addFavourite(uid: uid)
            button.setImage(Config.fullStar, for: .normal)
            isFavourite = true
        }
            
        button.addTarget(self, action: #selector(topRightBtnPressed), for: .touchUpInside)
        button.sizeToFit()
        
        topRightBtn.customView = button
    }
    
    @objc private func showFullScreenImage() {
        setUpFullScreenImageView()
        guard let currentUser = System.activeUser, let user = user, currentUser == user else {
            return
        }
        changeProfileImageToolbar.isHidden = false
        view.bringSubview(toFront: changeProfileImageToolbar)
    }
    
    private func setUpFullScreenImageView() {
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
    }
    
    @objc private func dismissFullScreenImage(sender: UITapGestureRecognizer) {
        guard sender.state == .ended else {
            return
        }
        changeProfileImageToolbar.isHidden = true
        sender.view?.removeFromSuperview()
    }

    @IBAction func changeProfileImage(_ sender: UIBarButtonItem) {
        guard System.client.isConnected else {
            present(Utility.getNoInternetAlertController(), animated: true, completion: nil)
            return
        }
        Utility.showImagePicker(imagePicker: imagePicker, viewController: self, completion: { (image) in
            if let image = image {
                self.updateImage(to: image)
            }
        })
    }
    
    func updateImage(to image: UIImage) {
        guard let user = user else {
            Utility.logOutUser(currentViewController: self)
            return
        }
        fullScreenImageView.image = image.cropSquareToCircle()
        user.profile.updateImage(image: image)
        System.activeUser?.profile.updateImage(image: image)
        System.client.updateUser(newUser: user)
    }
    
}

extension ProfileViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let profileItems = profileItems else {
            return 0
        }
        
        return profileItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.item
        
        guard let profileItems = profileItems, let cell =
            profileList.dequeueReusableCell(withIdentifier: Config.profileCell, for: indexPath) as? ProfileTableViewCell else {
            return ProfileTableViewCell()
        }
        
        let (field, content) = profileItems[index]
        cell.setUp(field: field, content: content)
        
        if content.isEmptyContent {
            cell.isHidden = true
        }
        
        return cell
    }
    
}
