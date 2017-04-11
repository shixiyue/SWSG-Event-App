//
//  EventPageViewController.swift
//  SWSG
//
//  Created by Jeremy Jee on 11/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import Firebase

class EventPageViewController: UIPageViewController {
    
    fileprivate var events = [Event]()
    fileprivate var eventViewControllers = [UIViewController]()
    
    fileprivate var firstLoaded = false
    
    fileprivate var eventsRef: FIRDatabaseReference?
    private var eventsAddedHandle: FIRDatabaseHandle?
    private var eventsRemovedHandle: FIRDatabaseHandle?
    
    fileprivate var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        observeDayEvents()
    }
    
    private func observeDayEvents() {
        let currentDateTime = Date.init()
        eventsRef = System.client.getEventRef(date: currentDateTime)
        
        eventsAddedHandle = eventsRef?.observe(.childAdded, with: { (snapshot) in
            guard let event = Event(id: snapshot.key, snapshot: snapshot) else {
                return
            }
            
            self.events.append(event)
            let viewController = self.getViewController(event: event)
            self.eventViewControllers.append(viewController)
            
            if !self.firstLoaded {
                self.setViewController()
                self.firstLoaded = true
            } else if currentDateTime < event.startDateTime {
                self.setViewController(viewController: viewController)
            }
        })
        
        System.client.checkHasEventsOn(by: Date.init(), completion: { (exists, error) in
            if !exists {
                let storyboard = UIStoryboard(name: Config.mainStoryboard, bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: Config.emptyEventView)
                
                self.setViewControllers([viewController],
                                        direction: .forward,
                                        animated: true,
                                        completion: nil)
            }
        })
    }
    
    fileprivate func setViewController() {
        guard index >= 0, index < eventViewControllers.count else {
            return
        }
        
        setViewController(viewController: eventViewControllers[index])
    }
    
    fileprivate func setViewController(viewController: UIViewController) {
        self.setViewControllers([viewController],
                                direction: .forward,
                                animated: true,
                                completion: nil)
    }
    
    fileprivate func getViewController(event: Event) -> UIViewController {
        let storyboard = UIStoryboard(name: Config.mainStoryboard, bundle: nil)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: Config.eventPageCellView) as? EventPageCellViewController, let id = event.id else {
            return UIViewController()
        }
        
        viewController.loadView()
        viewController.colorBorder.backgroundColor = Config.themeColor
        viewController.nameLbl.text = event.name
        
        let startTime = Utility.fbTimeFormatter.string(from: event.startDateTime)
        let endTime = Utility.fbTimeFormatter.string(from: event.endDateTime)
        viewController.timeLbl.text = "\(startTime) to \(endTime)"

        viewController.venueLbl.text = "@\(event.venue)"
        viewController.descTV.text = event.shortDesc
        viewController.imageView.isHidden = true
        
        Utility.getEventIcon(id: id, completion: { (image) in
            guard let image = image else {
                return
            }
            
            viewController.imageIV.image = image
            viewController.imageView.isHidden = false
        })
        
        return viewController
    }
}

// MARK: UIPageViewControllerDataSource
extension EventPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = eventViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0, eventViewControllers.count > previousIndex else {
            return nil
        }
        
        index = viewControllerIndex
        return eventViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = eventViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex >= 0, eventViewControllers.count > nextIndex else {
            return nil
        }
        
        index = viewControllerIndex
        return eventViewControllers[nextIndex]
    }
}
