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
    fileprivate var channels: [Channel] = []
    fileprivate var client = FirebaseClient()
    
    //MARK: Firebase References
    private var channelRef: FIRDatabaseReference!
    private var channelRefHandle: FIRDatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        
        channelRef = client.getChannelsRef()
        
        chatList.delegate = self
        chatList.dataSource = self
        
        observeChannels()
        chatList.reloadData()
    }
    
    // MARK: Firebase related methods
    private func observeChannels() {
        // Use the observe method to listen for new
        // channels being written to the Firebase DB
        channelRefHandle = channelRef.observe(.childAdded, with: { (snapshot) -> Void in
            let channelData = snapshot.value as! Dictionary<String, AnyObject>
            let id = snapshot.key
            let channel: Channel?
            if let name = channelData["name"] as? String, name.characters.count > 0 {
                channel = Channel(id: id, name: name)
                
                /*let childChannelRef = self.channelRef.child(id)
                let messageRef = childChannelRef!.child("messages")
                let messageQuery = messageRef.queryLimited(toLast:1)
                let newMessageRefHandle = messageQuery.observe(.childAdded, with: { (snapshot) -> Void in
                    let messageData = snapshot.value as! Dictionary<String, String>
                    
                    if let id = messageData["senderId"] as String!, let name = messageData["senderName"] as String!, let text = messageData["text"] as String!, text.characters.count > 0 {
                        channel.messages.append(Message.init(senderId: id, senderName: name, timestamp: nil, text: text, photoURL: nil))
                        self.addMessage(withId: id, name: name, text: text)
                        
                        // 5
                        self.finishReceivingMessage()
                    } else if let id = messageData["senderId"] as String!,
                        let photoURL = messageData["photoURL"] as String! { // 1
                        // 2
                        if let mediaItem = JSQPhotoMediaItem(maskAsOutgoing: id == self.senderId) {
                            // 3
                            self.addPhotoMessage(withId: id, key: snapshot.key, mediaItem: mediaItem)
                            // 4
                            if photoURL.hasPrefix("gs://") {
                                self.fetchImageDataAtURL(photoURL, forMediaItem: mediaItem, clearsPhotoMessageMapOnSuccessForKey: nil)
                            }
                        }
                    } else {
                        print("Error! Could not decode message data")
                    }
                })*/
                
                self.channels.append(channel!)
                self.chatList.reloadData()
            } else {
                print("Error! Could not decode channel data")
            }
        })
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let channel = sender as? Channel {
            guard let channelVC = Utility.getDestinationStoryboard(from: segue.destination) as? ChannelViewController else {
                return
            }
            
            channelVC.senderDisplayName = System.activeUser?.profile.name
            channelVC.channel = channel
            channelVC.channelRef = channelRef.child(channel.id)
        }
    }
    
    deinit {
        if let refHandle = channelRefHandle {
            channelRef.removeObserver(withHandle: refHandle)
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
        guard let cell = chatList.dequeueReusableCell(withIdentifier: "channelCell",
                                                                 for: indexPath) as? ChannelCell else {
                                                                    return ChannelCell()
        }
        
        let index = indexPath.item
        let channel = channels[index]
        
        cell.iconIV.image = channel.icon
        cell.nameLbl.text = channel.name
        
        //let latestMessage = channel.messages.last
        //cell.messageTV.text = latestMessage?.message
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension ChannelListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = channels[indexPath.item]
        self.performSegue(withIdentifier: Segues.channelListToChannel, sender: channel)
    }
}
