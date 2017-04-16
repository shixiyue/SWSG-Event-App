//
//  EventPageViewController.swift
//  SWSG
//
//  Created by Jeremy Jee on 11/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import Firebase

/**
    EventPageViewController is a UIPageViewController that displays the
    Latest Events Widget on the HomeViewConteollet
 */
class EventPageViewController: UIPageViewController {
    
    //MARK: Properties
    fileprivate var events = [Event]()
    fileprivate var eventIdentifier = [Int: Event]()
    fileprivate var eventViewControllers = [UIViewController]()
    fileprivate var firstLoaded = false
    fileprivate var isBefore = true
    fileprivate var index = 0
    
    //MARK: Firebase References
    fileprivate var eventsRef: FIRDatabaseReference?
    private var eventsAddedHandle: FIRDatabaseHandle?
    private var eventsRemovedHandle: FIRDatabaseHandle?
    
    //MARK: Intialization Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        observeDayEvents()
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == Config.homeToEventDetails, let event = sender as? Event {
            guard let detailsVC = segue.destination as? EventDetailsTableViewController else {
                return
            }
            
            detailsVC.event = event
        }
    }
    
    //MARK: Firebase Functions
    private func observeDayEvents() {
        let currentDateTime = Date.init()
        eventsRef = System.client.getEventRef(date: currentDateTime)
        
        eventsAddedHandle = eventsRef?.observe(.childAdded, with: { (snapshot) in
            guard let event = Event(id: snapshot.key, snapshot: snapshot) else {
                return
            }
            
            self.events.append(event)
            self.events = self.events.sorted(by: { $0.startDateTime < $1.startDateTime })
            
            for (index, childEvent) in self.events.enumerated() {
                if childEvent.id == event.id {
                    let viewController = self.getViewController(event: event)
                    self.eventViewControllers.insert(viewController, at: index)
                    
                    if !self.firstLoaded {
                        self.setViewController()
                        self.firstLoaded = true
                    } else if currentDateTime < event.startDateTime && self.isBefore {
                        self.setViewController(viewController: viewController)
                        self.isBefore = false
                    }
                }
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
    
    //MARK: UI Supporting Functions
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showEvent))
        viewController.stackView.addGestureRecognizer(tapGesture)
        viewController.stackView.tag = eventIdentifier.count
        
        eventIdentifier[eventIdentifier.count] = event
        
        Utility.getEventIcon(id: id, completion: { (image) in
            guard let image = image else {
                return
            }
            
            viewController.imageIV.image = image
            viewController.imageView.isHidden = false
        })
        
        return viewController
    }
    
    func showEvent(_ sender: UIGestureRecognizer){
        guard let view = sender.view else {
            return
        }
        
        let event = eventIdentifier[view.tag]
        
        performSegue(withIdentifier: Config.homeToEventDetails, sender: event)
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
