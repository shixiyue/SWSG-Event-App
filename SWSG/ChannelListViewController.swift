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
        channelsExistingHandle = channelsRef.observe(.value, with: { (snapshot) -> Void in
            self.channels = [Channel]()
            for channelData in snapshot.children {
                self.addNewChannel(snapshot: channelData)
            }
            self.chatList.reloadData()
        })
        
        channelsNewHandle = channelsRef.observe(.childAdded, with: { (snapshot) -> Void in
            self.addNewChannel(snapshot: snapshot)
        })
    }
    
    private func addNewChannel(snapshot: Any) {
        guard let channelSnapshot = snapshot as? FIRDataSnapshot,
            let channel = Channel(id: channelSnapshot.key, snapshot: channelSnapshot) else {
                return
        }
        self.client.fetchChannelIcon(for: channelSnapshot.key, completion: { (image) in
            channel.icon = image
            self.chatList.reloadData()
        })
        let query = self.client.getLatestMessageQuery(for: channelSnapshot.key)
        query.observe(.value, with: { (snapshot) in
            for child in snapshot.children {
                guard let mentorSnapshot = child as? FIRDataSnapshot,
                    let message = Message(snapshot: mentorSnapshot) else {
                        continue
                }
                
                channel.latestMessage = message
            }
            
        })
        self.channels.append(channel)
        
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
            chatVc.channelRef = channelsRef.child(channel.id)
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
        if channel.icon == nil {
            cell.iconIV.image = Config.placeholderImg
        } else {
            cell.iconIV.image = channel.icon
        }
        
        cell.iconIV = Utility.roundUIImageView(for: cell.iconIV)
        cell.nameLbl.text = channel.name
        
        if let message = channel.latestMessage {
            var text = ""
            
            if let msgText = message.text {
                text = "\(message.senderName): \(msgText)"
            } else if let message = channel.latestMessage, let _ = message.photoURL {
                text = "\(message.senderName) sent an image."
            }
            
            let nsText = text as NSString
            let textRange = NSMakeRange(0, message.senderName.characters.count + 2)
            let attributedString = NSMutableAttributedString(string: text)
            
            nsText.enumerateSubstrings(in: textRange, options: .byWords, using: {
                (substring, substringRange, _, _) in
                
                attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: substringRange)
                attributedString.addAttribute(NSFontAttributeName, value: UIFont.italicSystemFont(ofSize: 12.0), range: substringRange)
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
}
