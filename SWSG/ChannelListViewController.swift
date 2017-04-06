//
//  ChatListViewController.swift
//  SWSG
//
//  Created by Jeremy Jee on 23/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import Firebase

class ChannelListViewController: BaseViewController {
    @IBOutlet weak var chatList: UITableView!
    
    // MARK: Properties
    fileprivate var channels = [Channel]()
    fileprivate var client = System.client
    
    //MARK: Firebase References
    private var channelsRef: FIRDatabaseReference!
    private var channelsExistingHandle: FIRDatabaseHandle?
    private var channelsNewHandle: FIRDatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        
        channelsRef = client.getChannelsRef()
        
        chatList.delegate = self
        chatList.dataSource = self
        
        observeChannels()
        chatList.reloadData()
    }
    
    // MARK: Firebase related methods
    private func observeChannels() {
        channelsNewHandle = channelsRef.observe(.childAdded, with: { (snapshot) -> Void in
            self.addNewChannel(snapshot: snapshot)
            self.chatList.reloadData()
        })
        
        channelsExistingHandle = channelsRef.observe(.childChanged, with: { (snapshot) in
            for (index, channel) in self.channels.enumerated() {
                if snapshot.key == channel.id {
                    self.getLatestMessage(channel: channel, snapshot: snapshot)
                    
                    let indexPath = IndexPath(row: index, section: 0)
                    self.chatList.reloadRows(at: [indexPath], with: .automatic)
                    break
                }
            }
        })
    }
    
    private func addNewChannel(snapshot: Any) {
        guard let channelSnapshot = snapshot as? FIRDataSnapshot,
            let channel = Channel(id: channelSnapshot.key, snapshot: channelSnapshot) else {
                return
        }
        
        Utility.getChatIcon(id: channelSnapshot.key, completion: { (image) in
            if let image = image {
                channel.icon = image
                self.chatList.reloadData()
            }
        })
        
        getLatestMessage(channel: channel, snapshot: channelSnapshot)
        
        self.channels.append(channel)
        
    }
    
    private func getLatestMessage(channel: Channel, snapshot: FIRDataSnapshot) {
        let query = self.client.getLatestMessageQuery(for: snapshot.key)
        query.observe(.value, with: { (snapshot) in
            for child in snapshot.children {
                guard let mentorSnapshot = child as? FIRDataSnapshot,
                    let message = Message(snapshot: mentorSnapshot) else {
                        continue
                }
                
                channel.latestMessage = message
            }
            
        })
        
    }
    
    @IBAction func composeBtnPressed(_ sender: Any) {
        let composeController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let channelAction = UIAlertAction(title: "Group Channel", style: .default, handler: {
            _ in
            self.performSegue(withIdentifier: Config.channelListToCreateChannel, sender: self)
        })
        composeController.addAction(channelAction)
        
        let directAction = UIAlertAction(title: "Direct Message", style: .default, handler: {
            _ in
            self.createDirectChatPressed(existingText: "")
        })
        composeController.addAction(directAction)
        
        //Add a Cancel Action to the Popup
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
        }
        composeController.addAction(cancelAction)
        
        composeController.popoverPresentationController?.sourceView = self.view
        
        //Displays the Compose Popup
        self.present(composeController, animated: true, completion: nil)
    }
    
    //Handling Creating a Direct Chat
    private func createDirectChatPressed(existingText: String) {
        //Creating a Alert Popup for Saving
        let message = "Who do you want to message?"
        let createController = UIAlertController(title: "Direct Message", message: message,
                                               preferredStyle: UIAlertControllerStyle.alert)
        
        //Creates a Save Button for the Popup
        let createAction = UIAlertAction(title: "Create", style: .default) { _ -> Void in
            
            if let nameTF = createController.textFields?[0] {
                guard var username = nameTF.text else {
                    return
                }
                
                username = username.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                
                self.client.getUserWith(username: username, completion: { (user, error) in
                    guard let user = user, let userUID = user.uid else {
                        Utility.displayDismissivePopup(title: "Error", message: "Username does not exist!", viewController: self, completion: { _ in
                            self.createDirectChatPressed(existingText: username)
                        })
                        return
                    }
                    
                    var members = [String]()
                    members.append(self.client.getUid())
                    members.append(userUID)
                    
                    let channel = Channel(type: .directMessage, members: members)
                    self.client.createChannel(for: channel)
                })
            }
        }
        createController.addAction(createAction)
        
        //Creates a Cancel Button for the Popup
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
        }
        createController.addAction(cancelAction)
        
        //Creates a Textfield to enter the Level Name in the Popup
        createController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Username"
            
            if existingText.characters.count > 0 {
                textField.text = existingText
            }
            
            //Disable the Save Button by default
            createAction.isEnabled = false
            
            textField.textAlignment = .center
            textField.delegate = self
            textField.returnKeyType = .done
            
            //Sets the Save Button to disabled if the textfield is empty
            NotificationCenter.default.addObserver(
                forName: NSNotification.Name.UITextFieldTextDidChange,
                object: textField, queue: OperationQueue.main) { _ in
                    guard var text = textField.text else {
                        return
                    }
                    text = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    
                    if text != "" {
                        createAction.isEnabled = true
                    } else {
                        createAction.isEnabled = false
                    }
            }
        })
        
        //Displays the Save Popup
        self.present(createController, animated: true, completion: nil)
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let channel = sender as? Channel {
            guard let chatVc = segue.destination as? ChannelViewController else {
                return
            }
            
            chatVc.senderDisplayName = System.activeUser?.profile.username
            chatVc.channel = channel
        }
    }
    
    deinit {
        if let existingHandle = channelsExistingHandle {
            channelsRef.removeObserver(withHandle: existingHandle)
        }
        
        if let newHandle = channelsNewHandle {
            channelsRef.removeObserver(withHandle: newHandle)
        }
    }
}

// MARK: UITableViewDataSource
extension ChannelListViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    public func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Config.channelCell, for: indexPath) as? ChannelCell else {
                return ChannelCell()
        }
        
        let index = indexPath.item
        let channel = channels[index]
        cell.iconIV = Utility.roundUIImageView(for: cell.iconIV)
        
        if channel.type == .directMessage {
            var otherUID: String?
            
            for member in channel.members {
                if member != client.getUid() {
                    otherUID = member
                    break
                }
            }
            
            guard let uid = otherUID else {
                return ChannelCell()
            }
            
            cell.iconIV.image = Config.placeholderImg
            
            Utility.getProfileImg(uid: uid, completion: { (image) in
                if let image = image {
                    cell.iconIV.image = image
                }
            })
            
            client.getUserWith(uid: uid, completion: { (user, error) in
                cell.nameLbl.text = user?.profile.name
            })
        } else if channel.type != .directMessage {
            
            if channel.icon == nil {
                cell.iconIV.image = Config.placeholderImg
            } else {
                cell.iconIV.image = channel.icon
            }
            
            cell.nameLbl.text = channel.name
        }
        
        
        if let message = channel.latestMessage {
            var text = ""
            
            var senderName = message.senderName
            
            if message.senderId == client.getUid() {
                senderName = "Me"
            }
            
            if let msgText = message.text {
                text = "\(senderName): \(msgText)"
            } else if message.image != nil {
                text = "\(senderName) sent an image."
            }
            
            let nsText = text as NSString
            let textRange = NSMakeRange(0, senderName.characters.count + 1)
            let attributedString = NSMutableAttributedString(string: text)
            
            nsText.enumerateSubstrings(in: textRange, options: .byWords, using: {
                (substring, substringRange, _, _) in
                
                attributedString.addAttribute(NSForegroundColorAttributeName,
                                              value: Config.themeColor,
                                              range: substringRange)
                attributedString.addAttribute(NSFontAttributeName,
                                              value: UIFont.italicSystemFont(ofSize: 12.0),
                                              range: substringRange)
            })
            
            cell.messageTV.attributedText = attributedString
        } else {
            cell.messageTV.text = "No messages yet"
        }
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension ChannelListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = channels[indexPath.item]
        self.performSegue(withIdentifier: Config.channelListToChannel, sender: channel)
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let channel = channels[indexPath.row]
            client.deleteChannel(for: channel)
            channels.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let channel = channels[indexPath.row]
        
        if channel.type == .directMessage {
            return true
        } else {
            return false
        }
    }
}

// MARK: UITextFieldDelegate
extension ChannelListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
