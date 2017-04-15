//
//  ChannelInfoViewController.swift
//  SWSG
//
//  Created by Jeremy Jee on 6/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import Firebase

class ChannelInfoViewController: UIViewController {
    @IBOutlet weak var iconIV: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var membersList: UITableView!
    @IBOutlet weak var quitBtn: RoundCornerButton!
    @IBOutlet weak var addBtn: RoundCornerButton!
    @IBOutlet weak var editNameBtn: UIButton!
    
    var channel: Channel!
    var members = [User]()
    fileprivate let client = System.client
    fileprivate var imagePicker = ImagePickCropperPopoverViewController()
    
    fileprivate var channelRef: FIRDatabaseReference?
    private var channelExistingHandle: FIRDatabaseHandle?
    private var membersNewHandle: FIRDatabaseHandle?
    private var membersRemovedHandle: FIRDatabaseHandle?
    
    override func viewDidLoad() {
        iconIV = Utility.roundUIImageView(for: iconIV)
        iconIV.image = Config.placeholderImg
        
        membersList.delegate = self
        membersList.dataSource = self
        
        guard let id = channel.id else {
            return
        }
        
        channelRef = client.getChannelRef(for: id)
        
        observeChannel()
        
        let tapIconGesture = UITapGestureRecognizer(target: self, action: #selector(editIcon))
        iconIV.addGestureRecognizer(tapIconGesture)
        
        let tapNameGesture = UITapGestureRecognizer(target: self, action: #selector(editName))
        nameLbl.addGestureRecognizer(tapNameGesture)
        
        if channel.type == .team {
            quitBtn.isHidden = true
            addBtn.isHidden = true
            editNameBtn.isHidden = true
            nameLbl.isUserInteractionEnabled = false
        } else if channel.type == .publicChannel {
            membersList.isHidden = true
            quitBtn.isHidden = true
            addBtn.isHidden = true
            editNameBtn.isHidden = true
            nameLbl.isUserInteractionEnabled = false
        }
    }
    
    // MARK: Firebase related methods
    private func observeChannel() {
        membersNewHandle = channelRef?.child(Config.members).observe(.childAdded, with: { (snapshot) -> Void in
            guard let memberUID = snapshot.value as? String else {
                return
            }
            
            self.client.getUserWith(uid: memberUID, completion: { (user, error) in
                guard error == nil, let user = user else {
                    return
                }
                
                self.members.append(user)
                self.membersList.reloadData()
            })
            
        })
        
        channelExistingHandle = channelRef?.observe(.value, with: { (snapshot) in
            guard let id = self.channel.id, let channel = Channel(id: id, snapshot: snapshot) else {
                return
            }
            
            self.nameLbl.text = channel.name
            
            Utility.getChatIcon(id: id, completion: { (image) in
                if let image = image {
                    self.iconIV.image = image
                }
            })
            
        })
        
        membersRemovedHandle = channelRef?.child(Config.members).observe(.childRemoved, with: { (snapshot) -> Void in
            print(snapshot)
        })
    }
    
    @IBAction func editIconBtnPressed(_ sender: Any) {
        editIcon()
    }
    
    @IBAction func editNameBtnPressed(_ sender: Any) {
        editName()
    }
    
    @IBAction func addMemberBtnPressed(_ sender: Any) {
        addMember(existingText: "")
    }
    
    @IBAction func quitChatBtnPressed(_ sender: Any) {
        guard let uid = System.client.getUid() else {
            Utility.logOutUser(currentViewController: self)
            return
        }
        
        self.client.removeMember(from: channel, uid: uid)
        
        Utility.popViewController(no: 2, viewController: self)
    }
    
    func editIcon() {
        Utility.showImagePicker(imagePicker: imagePicker, viewController: self, completion: { (image) in
            if let image = image {
                self.client.updateChannel(icon: image, for: self.channel)
            }
        })
    }
    
    func editName() {
        guard let channel = channel, let name = channel.name else {
            return
        }
        
        let title = "Change Name?"
        let message = "Change the Channel Name to?"
        let btnText = "Change"
        let placeholderText = "Channel Name"
        let existingText = "\(name)"
        Utility.createPopUpWithTextField(title: title, message: message,
                                         btnText: btnText, placeholderText: placeholderText,
                                         existingText: existingText, viewController: self,
                                         completion: { (name) in
            self.client.updateChannel(name: name, for: channel)
            self.channel.name = name
            self.nameLbl.text = name
        })
    }
    
    func addMember(existingText: String) {
        
        let title = "Add New Member"
        let message = "Enter the User's Username"
        let btnText = "Add"
        let placeholderText = "Username"
        let existingText = "\(existingText)"
        Utility.createPopUpWithTextField(title: title, message: message,
                                         btnText: btnText, placeholderText: placeholderText,
                                         existingText: existingText, viewController: self,
                                         completion: { (name) in
            self.client.getUserWith(username: name, completion: { (user, error) in
                guard let user = user, let _ = user.uid else {
                    Utility.displayDismissivePopup(title: "Error", message: "Username does not exist!", viewController: self, completion: { _ in
                        self.addMember(existingText: name)
                    })
                    return
                }
                
                for member in self.members {
                    guard member.uid != user.uid else {
                        Utility.displayDismissivePopup(title: "Error",
                                                       message: "Username already added",
                                                       viewController: self, completion: { _ in })
                        return
                    }
                }
                
                self.client.addMember(to: self.channel, member: user)
                self.membersList.reloadData()
                self.view.endEditing(true)
            })
            
        })
    }

}

// MARK: UITableViewDataSource
extension ChannelInfoViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    public func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Config.memberCell,
                                                       for: indexPath) as? MemberCell else {
                                                        return MemberCell()
        }
        
        let index = indexPath.item
        let member = members[index]
        
        cell.iconIV = Utility.roundUIImageView(for: cell.iconIV)
        cell.iconIV.image = Config.placeholderImg
        
        Utility.getProfileImg(uid: member.uid!, completion: { (image) in
            if let image = image {
                cell.iconIV.image = image
            }
        })
        
        
        cell.iconIV = Utility.roundUIImageView(for: cell.iconIV)
        cell.nameLbl.text = "\(member.profile.name) (@\(member.profile.username))"
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension ChannelInfoViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView,
                               editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?{
        if members[indexPath.item].uid == client.getUid() {
            let action = UITableViewRowAction()
            action.title = "Quit"
            action.backgroundColor = Config.themeColor
            return [action]
        } else {
            let action = UITableViewRowAction()
            action.title = "Delete"
            action.backgroundColor = Config.themeColor
            return [action]
        }
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            members.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if members[indexPath.item].uid == client.getUid() || channel.type != .privateChannel {
            return false
        } else {
            return true
        }
    }
}

// MARK: UITextFieldDelegate
extension ChannelInfoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

