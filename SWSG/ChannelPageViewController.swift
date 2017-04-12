//
//  ChannelPageViewController.swift
//  SWSG
//
//  Created by Jeremy Jee on 12/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import Firebase

class ChannelPageViewController: UIPageViewController {
    fileprivate var channels = [Channel]()
    fileprivate var channelIdentifier = [Int: Channel]()
    fileprivate var channelViewControllers = [UIViewController]()
    
    fileprivate var firstLoaded = false
    
    fileprivate var channelsRef: FIRDatabaseReference?
    private var channelsAddedHandle: FIRDatabaseHandle?
    
    fileprivate var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        observeChannels()
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == Config.homeToChat, let channel = sender as? Channel {
            guard let channelVC = segue.destination as? ChannelViewController else {
                return
            }
            
            channelVC.senderDisplayName = System.activeUser?.profile.username
            channelVC.channel = channel
        }
    }
    
    private func observeChannels() {
        channelsRef = System.client.getChannelsRef()
        
        channelsAddedHandle = channelsRef?.observe(.childAdded, with: { (snapshot) in
            guard let channel = Channel(id: snapshot.key, snapshot: snapshot),
                Utility.validChannel(channel) else {
                    if self.channelViewControllers.count == 0 {
                        self.setEmptyChat()
                    }
                    
                    return
            }
            
            Utility.getLatestMessage(channel: channel, snapshot: snapshot, completion: { () in
                self.channels.append(channel)
                self.channels = Utility.channelsSortedByLatestMessage(channels: self.channels)
                
                for (index, childChannel) in self.channels.enumerated() {
                    if childChannel.id == channel.id {
                        let viewController = self.getViewController(channel: channel)
                        self.channelViewControllers.insert(viewController, at: index)
                        
                        self.setViewController()
                        return
                    }
                }
            })
        })
    }
    
    fileprivate func setEmptyChat() {
        let storyboard = UIStoryboard(name: Config.mainStoryboard, bundle: nil)
        let emptyChat = storyboard.instantiateViewController(withIdentifier: Config.emptyChatView)
        
        setViewController(viewController: emptyChat)
    }
    
    fileprivate func setViewController() {
        guard index >= 0, index < channelViewControllers.count, channelViewControllers.count > 0 else {
            return
        }
        
        setViewController(viewController: channelViewControllers.first!)
    }
    
    fileprivate func setViewController(viewController: UIViewController) {
        self.setViewControllers([viewController],
                                direction: .forward,
                                animated: true,
                                completion: nil)
    }
    
    fileprivate func getViewController(channel: Channel) -> UIViewController {
        let storyboard = UIStoryboard(name: Config.mainStoryboard, bundle: nil)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: Config.channelPageCellView) as? ChannelPageCellController, let id = channel.id else {
            return UIViewController()
        }
        
        viewController.loadView()
        viewController.iconIV = Utility.roundUIImageView(for: viewController.iconIV)
        viewController.iconIV.image = Config.placeholderImg
        
        if channel.type == .directMessage {
            Utility.getOtherUser(in: channel, completion: { (user) in
                if let user = user, let uid = user.uid {
                    viewController.nameLbl.text = user.profile.name
                    
                    Utility.getProfileImg(uid: uid, completion: { (image) in
                        if let image = image {
                            viewController.iconIV.image = image
                        }
                    })
                }
            })
        } else {
            viewController.nameLbl.text = channel.name
            
            Utility.getChatIcon(id: id, completion: { (image) in
                if let image = image {
                    viewController.iconIV.image = image
                }
            })
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showChannel))
        viewController.channelView.addGestureRecognizer(tapGesture)
        viewController.channelView.tag = channelIdentifier.count
        
        channelIdentifier[channelIdentifier.count] = channel
        
        if let msg = channel.latestMessage, let text = msg.text {
            viewController.messageTV.text = "\(msg.senderName) sent \(text)"
        } else if let msg = channel.latestMessage, let _ = msg.image {
            viewController.messageTV.text = "\(msg.senderName) sent an Image"
        } else {
            viewController.messageTV.text = "No messages sent"
        }
        
        return viewController
    }
    
    func showChannel(sender: UIGestureRecognizer) {
        guard let view = sender.view else {
            return
        }
        
        
        let channel = channelIdentifier[view.tag]
        
        performSegue(withIdentifier: Config.homeToChat, sender: channel)
    }
}

// MARK: UIPageViewControllerDataSource
extension ChannelPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = channelViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0, channelViewControllers.count > previousIndex else {
            return nil
        }
        
        index = viewControllerIndex
        return channelViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = channelViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex >= 0, channelViewControllers.count > nextIndex else {
            return nil
        }
        
        index = viewControllerIndex
        return channelViewControllers[nextIndex]
    }
}
