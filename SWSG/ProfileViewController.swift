//
//  ProfileViewController.swift
//  SWSG
//
//  Created by shixiyue on 17/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: ImagePickerViewController, UIGestureRecognizerDelegate {

    @IBOutlet private var profileImgButton: UIButton!
    @IBOutlet private var nameLbl: UILabel!
    @IBOutlet private var usernameLbl: UILabel!
    @IBOutlet private var teamLbl: UILabel!
    @IBOutlet fileprivate var profileList: UITableView!
    @IBOutlet private var changeProfileImageToolbar: UIToolbar!
    
    @IBOutlet weak var composeBtn: UIImageView!
    @IBOutlet weak var topRightBtn: UIBarButtonItem!
    private var fullScreenImageView: UIImageView!

    var user: User?
    fileprivate var isActiveUser: Bool = false
    fileprivate var isFavourite = false
    fileprivate var profileItems: [(String, String)]?
    private let imagePicker = UIImagePickerController()
    
    fileprivate var userRef: FIRDatabaseReference?
    private var userExistingHandle: FIRDatabaseHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImgButton.setImage(Config.placeholderImg, for: .normal)
        observeUser()
        setUpProfileList()
        imagePicker.delegate = self
        changeProfileImageToolbar.isHidden = true
        
        
        setUpTopRightBtn()
        setUpChatButton() 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        profileList.reloadData()
        setUpUserInfo()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == Config.profileToChannel, let channel = sender as? Channel {
            guard let chatVc = segue.destination as? ChannelViewController else {
                return
            }
            
            chatVc.senderDisplayName = System.activeUser?.profile.username
            chatVc.channel = channel
        }
    }
    
    // MARK: Firebase related methods
    private func observeUser() {
        guard let uid = user?.uid else {
            return
        }
        
        userRef = System.client.getUserRef(for: uid)
        userExistingHandle = userRef?.observe(.value, with: { (snapshot) in
            guard let user = User(snapshot: snapshot) else {
                return
            }
            
            user.setUid(uid: uid)
            self.user = user
            
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
    
    private func setUpUserInfo() {
        guard let user = user else {
            return
        }
        
        profileItems = ProfileItems.getItems(user: user)
        
        profileImgButton.setImage(user.profile.image, for: .normal)
        profileImgButton.addTarget(self, action: #selector(showFullScreenImage), for: .touchUpInside)
        
        nameLbl.text = user.profile.name
        usernameLbl.text = "@\(user.profile.username)"
        
        guard user.type.isParticipant else {
            teamLbl.text = user.type.toString()
            return
        }
        
        if user.team != Config.noTeam {
            Teams().retrieveTeamWith(id: user.team, completion: { (team) in
                guard let team = team else {
                    self.teamLbl.text = Config.noTeamLabel
                    return
                }
                self.teamLbl.text = team.name
            })
        } else {
            teamLbl.text = Config.noTeamLabel
        }
    }
    
    private func setUpTopRightBtn() {
        guard let user = user, let activeUser = System.activeUser,
            let uid = user.uid, let activeUID = activeUser.uid else {
            isActiveUser = false
            return
        }
        
        if uid != activeUID {
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
        } else {
            isActiveUser = true
        }
    }
    
    private func setUpChatButton() {
        if !isActiveUser {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(composeBtnPressed))
            composeBtn.addGestureRecognizer(tapGesture)
            composeBtn.isHidden = false
        }
    }
    
    func composeBtnPressed(_ sender: UITapGestureRecognizer) {
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
        } else {
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
    }
    
    override func updateImage(to image: UIImage) {
        guard let user = user else {
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
        
        cell.field.text = field
        cell.content.text = content
        return cell
    }
    
}
