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
    
    var channel: Channel!
    var members = [User]()
    fileprivate var imagePicker = ImagePickerPopoverViewController()
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
        
        channelRef = System.client.getChannelRef(for: id)
        
        observeChannel()
        
        let tapIconGesture = UITapGestureRecognizer(target: self, action: #selector(editIcon))
        iconIV.addGestureRecognizer(tapIconGesture)
    }
    
    // MARK: Firebase related methods
    private func observeChannel() {
        membersNewHandle = channelRef?.child(Config.members).observe(.childAdded, with: { (snapshot) -> Void in
            guard let memberUID = snapshot.value as? String else {
                return
            }
            
            System.client.getUserWith(uid: memberUID, completion: { (user, error) in
                guard error == nil, let user = user else {
                    return
                }
                
                self.members.append(user)
                print(self.members.count)
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
    
    func editIcon() {
        let completionHandler: (UIImage?)->Void = { (image) in
            if let image = image {
                System.client.updateChannel(icon: image, for: self.channel)
            }
        }
        
        imagePicker.modalPresentationStyle = .overCurrentContext
        imagePicker.completionHandler = completionHandler
        
        present(imagePicker, animated: true, completion: nil)
        imagePicker.showImageOptions()
    }
    
    @IBAction func editNameBtnPressed(_ sender: Any) {
    }
    
    @IBAction func addMemberBtnPressed(_ sender: Any) {
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
                self.membersList.reloadRows(at: [indexPath], with: .automatic)
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
        if members[indexPath.item].uid == System.client.getUid() {
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
        if members[indexPath.item].uid == System.client.getUid() {
            return false
        } else {
            return true
        }
    }
    
}

