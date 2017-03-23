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
    private lazy var channelRef: FIRDatabaseReference = FIRDatabase.database().reference().child("channels")
    private var channelRefHandle: FIRDatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        
        chatList.delegate = self
        chatList.dataSource = self
        
        observeChannels()
        chatList.reloadData()
    }
    
    // MARK: Firebase related methods
    private func observeChannels() {
        // Use the observe method to listen for new
        // channels being written to the Firebase DB
        channelRefHandle = channelRef.observe(.childAdded, with: { (snapshot) -> Void in // 1
            let channelData = snapshot.value as! Dictionary<String, AnyObject> // 2
            let id = snapshot.key
            if let name = channelData["name"] as! String!, name.characters.count > 0 { // 3
                self.channels.append(Channel(id: id, name: name))
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
            let navController = segue.destination as! UINavigationController
            let channelVC = navController.viewControllers[0] as! ChannelViewController
            
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
        
        let latestMessage = channel.messages.last
        cell.messageTV.text = latestMessage?.message
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension ChannelListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = channels[indexPath.item]
        self.performSegue(withIdentifier: "showChannel", sender: channel)
    }
}
