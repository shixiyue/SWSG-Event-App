//
//  ChatListViewController.swift
//  SWSG
//
//  Created by Jeremy Jee on 23/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import Firebase

/**
    ChannelListViewController is a UIViewController, inherits from BaseViewController
    for the menu, that displays a list of all channels available to the user.
 
    It also allows the user to press a button to create a new Channel either as
    a group chat or a direct chat.

*/

class ChannelListViewController: BaseViewController {
    @IBOutlet weak var chatList: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: Properties
    fileprivate var channels = [Channel]()
    fileprivate var filteredChannels = [Channel]()
    fileprivate var directMessageChannelName = [String: String]()
    fileprivate var client = System.client
    fileprivate var searchActive = false {
        willSet(newSearchActive) {
            chatList.reloadData()
        }
    }
    
    //MARK: Firebase References
    private var channelsRef: FIRDatabaseReference!
    private var channelsExistingHandle: FIRDatabaseHandle?
    private var channelsNewHandle: FIRDatabaseHandle?
    private var channelsDeletedHandle: FIRDatabaseHandle?
    
    //MARK: Intialization and Deinitialization
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        
        channelsRef = client.getChannelsRef()
        
        chatList.delegate = self
        chatList.dataSource = self
        
        setUpSearchBar()
        observeChannels()
        chatList.reloadData()
    }
    
    deinit {
        if let existingHandle = channelsExistingHandle {
            channelsRef.removeObserver(withHandle: existingHandle)
        }
        
        if let newHandle = channelsNewHandle {
            channelsRef.removeObserver(withHandle: newHandle)
        }
        
        if let deletedHandle = channelsDeletedHandle {
            channelsRef.removeObserver(withHandle: deletedHandle)
        }
    }
    
    //MARK: UI Set Up
    private func setUpSearchBar() {
        Utility.setUpSearchBar(searchBar, viewController: self, selector: #selector(donePressed))
        Utility.styleSearchBar(searchBar)
    }
    
    func donePressed() {
        self.view.endEditing(true)
    }
    
    // MARK: Firebase related methods
    private func observeChannels() {
        channelsNewHandle = channelsRef.observe(.childAdded, with: { (snapshot) -> Void in
            self.addNewChannel(snapshot: snapshot)
            self.chatList.reloadData()
        })
        
        channelsExistingHandle = channelsRef.observe(.childChanged, with: { (snapshot) in
            var removedObjects = 0
            
            guard let uid = System.client.getUid() else {
                Utility.logOutUser(currentViewController: self)
                return
            }
            
            for (index, channel) in self.channels.enumerated() {
                if snapshot.key == channel.id {
                    guard let channel = Channel(id: snapshot.key, snapshot: snapshot) else {
                        return
                    }
                    
                    guard channel.members.contains(uid) else {
                        let indexToRemove = index - removedObjects
                        self.channels.remove(at: indexToRemove)
                        self.chatList.reloadData()
                        removedObjects += 1
                        
                        return
                    }
                    
                    self.channels[index].name = channel.name
                    
                    let indexPath = IndexPath(row: index, section: 0)
                    
                    Utility.getLatestMessage(channel: channel, snapshot: snapshot, completion: { _ in
                        self.channels = Utility.channelsSortedByLatestMessage(channels: self.channels)
                        self.chatList.reloadRows(at: [indexPath], with: .automatic)
                    })
                    self.chatList.reloadRows(at: [indexPath], with: .automatic)
                    break
                }
            }
        })
        
        channelsDeletedHandle = channelsRef.observe(.childRemoved, with: { (snapshot) in
            for (index, channel) in self.channels.enumerated() {
                if snapshot.key == channel.id {
                    self.channels.remove(at: index)
                    self.chatList.reloadData()
                    break
                }
            }
        })
    }
    
    private func addNewChannel(snapshot: Any) {
        guard let channelSnapshot = snapshot as? FIRDataSnapshot,
            let channel = Channel(id: channelSnapshot.key, snapshot: channelSnapshot),
            Utility.validChannel(channel) else {
                return
        }
        
        Utility.getLatestMessage(channel: channel, snapshot: channelSnapshot, completion: { _ in
            self.chatList.reloadData()
        })
        self.channels.append(channel)
    }
    
    
/**
     When pressing the Compose Button, an action sheet will be displayed showing
     the various options available for creating a new chat.
     
     Most Users are able to create Group Channels and Direct Messages
     Only Admin/Organizers are able to create Public Channels
 */
    @IBAction func composeBtnPressed(_ sender: Any) {
        let composeController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if System.activeUser?.type.isAdmin == true || System.activeUser?.type.isOrganizer == true {
            let publicChannelAction = UIAlertAction(title: "Public Channel", style: .default, handler: {
                _ in
                self.performSegue(withIdentifier: Config.channelListToCreateChannel, sender: true)
            })
            composeController.addAction(publicChannelAction)
        }
        
        let channelAction = UIAlertAction(title: "Group Channel", style: .default, handler: {
            _ in
            self.performSegue(withIdentifier: Config.channelListToCreateChannel, sender: false)
        })
        composeController.addAction(channelAction)
        
        let directAction = UIAlertAction(title: "Direct Message", style: .default, handler: {
            _ in
            self.createDirectChatPressed(existingText: "")
        })
        composeController.addAction(directAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
        }
        composeController.addAction(cancelAction)
        
        composeController.popoverPresentationController?.sourceView = self.view
        
        self.present(composeController, animated: true, completion: nil)
    }
    
    //Handling Creating a Direct Chat
    private func createDirectChatPressed(existingText: String) {
        let message = "Who do you want to message?"
        let title = "Direct Message"
        let btnText = "Create"
        let placeholder = "Username"
        
        guard let uid = client.getUid() else {
            Utility.logOutUser(currentViewController: self)
            return
        }
        
        Utility.createPopUpWithTextField(title: title, message: message,
                                         btnText: btnText, placeholderText: placeholder,
                                         existingText: existingText,
                                         viewController: self,
                                         completion: { (username) in
            self.client.getUserWith(username: username, completion: { (user, error) in
                guard let user = user, let userUID = user.uid,
                    userUID != self.client.getUid() else {
                    Utility.displayDismissivePopup(title: "Error", message: "Invalid Username", viewController: self, completion: { _ in
                        self.createDirectChatPressed(existingText: username)
                    })
                    return
                }
                
                var members = [String]()
                members.append(uid)
                members.append(userUID)
                
                let channel = Channel(type: .directMessage, members: members)
                self.client.createChannel(for: channel, completion: { (channel, error) in
                    guard error == nil else {
                        return
                    }
                    self.performSegue(withIdentifier: Config.channelListToChannel, sender: channel)
                })
            })
            
        })
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == Config.channelListToCreateChannel,
            let isPublic = sender as? Bool,
            let createVc = segue.destination as? CreateChannelViewController {
            createVc.isPublic = isPublic
        } else if segue.identifier == Config.channelListToChannel,
            let channel = sender as? Channel,
            let chatVc = segue.destination as? ChannelViewController {
            chatVc.senderDisplayName = System.activeUser?.profile.username
            chatVc.channel = channel
        }
    }
}

// MARK: UITableViewDataSource
extension ChannelListViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive && searchBar.text != "" {
            return filteredChannels.count
        }
        return channels.count
    }
    
    public func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Config.channelCell, for: indexPath) as? ChannelCell else {
                return ChannelCell()
        }
        
        let index = indexPath.item
        let channel: Channel
        if searchActive && searchBar.text != "" {
            channel = filteredChannels[index]
        } else {
            channel = channels[index]
        }
        cell.iconIV = Utility.roundUIImageView(for: cell.iconIV)
        cell.iconIV.image = Config.placeholderImg
        
        guard let channelID = channel.id else {
            return ChannelCell()
        }
        
        if channel.type == .directMessage {
            Utility.getOtherUser(in: channel, completion: { (user) in
                if let user = user, let uid = user.uid {
                    cell.nameLbl.text = user.profile.name
                    self.directMessageChannelName[channelID] = user.profile.name
                    
                    Utility.getProfileImg(uid: uid, completion: { (image) in
                        if let image = image {
                            cell.iconIV.image = image
                        }
                    })
                }
            })
        } else if channel.type != .directMessage {
            Utility.getChatIcon(id: channelID, completion: { (image) in
                if let image = image {
                    cell.iconIV.image = image
                }
            })
            
            cell.nameLbl.text = channel.name
        }
        
        if let message = channel.latestMessage {
            var text = ""
            
            var senderName = message.senderName
            
            if message.senderId == client.getUid() {
                senderName = "You"
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
        let channel: Channel
        let index = indexPath.item
        
        if searchActive && searchBar.text != "" {
            channel = filteredChannels[index]
        } else {
            channel = channels[index]
        }
        
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
        let canDeletePublic = System.activeUser?.type.isAdmin == true || System.activeUser?.type.isOrganizer == true
        
        if channel.type == .directMessage || (channel.type == .publicChannel && canDeletePublic) {
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

// MARK: UISearchResultsUpdating
extension ChannelListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredChannels = channels.filter { channel in
            if channel.type == .directMessage, let channelID = channel.id  {
                guard directMessageChannelName.keys.contains(channelID),
                    let otherPersonName = directMessageChannelName[channelID] else {
                        return false
                }
                
                return otherPersonName.lowercased().contains(searchText.lowercased())
            } else if let name = channel.name {
                return name.lowercased().contains(searchText.lowercased())
            } else {
                return false
            }
        }
        
        Utility.setSearchActive(&searchActive, searchBar: searchBar)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        Utility.setSearchActive(&searchActive, searchBar: searchBar)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        Utility.setSearchActive(&searchActive, searchBar: searchBar)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        Utility.setSearchActive(&searchActive, searchBar: searchBar)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Utility.setSearchActive(&searchActive, searchBar: searchBar)
        Utility.searchBtnPressed(viewController: self)
    }
}
