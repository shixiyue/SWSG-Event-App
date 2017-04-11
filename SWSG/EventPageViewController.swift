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
    
    weak var eventDelegate: EventPageViewControllerDelegate?
    
    fileprivate var events = [Event]()
    fileprivate var eventViewControllers = [UIViewController]()
    
    fileprivate var eventsRef: FIRDatabaseReference?
    private var eventsAddedHandle: FIRDatabaseHandle?
    private var eventsRemovedHandle: FIRDatabaseHandle?
    
    fileprivate var index = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        eventDelegate?.eventPageViewController(self, didUpdatePageCount: eventViewControllers.count)
        
        observeDayEvents()
    }
    
    private func observeDayEvents() {
        eventsRef = System.client.getEventRef(date: Date.init())
        
        eventsAddedHandle = eventsRef?.observe(.childAdded, with: { (snapshot) in
            guard let event = Event(id: snapshot.key, snapshot: snapshot) else {
                return
            }
            
            self.events.append(event)
            self.eventViewControllers.append(self.getViewController(event: event))
            self.setViewController()
        })
    }
    
    fileprivate func setViewController() {
        guard index > 0, index < eventViewControllers.count else {
            return
        }
        
        print("test")
        self.setViewControllers([eventViewControllers[index]],
                                direction: .forward,
                                animated: true,
                                completion: nil)
        print("test2")
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
        viewController.imageIV.isHidden = true
        
        Utility.getEventIcon(id: id, completion: { (image) in
            guard let image = image else {
                return
            }
            
            viewController.imageIV.image = image
            viewController.imageIV.isHidden = false
        })
        
        return viewController
    }
}

// MARK: UIPageViewControllerDataSource
extension EventPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let previousIndex = index - 1
        print("previous: \(previousIndex)")
        print(eventViewControllers.count)
        
        guard previousIndex > 0, eventViewControllers.count > previousIndex else {
            return nil
        }
        
        index = previousIndex
        print("load \(index)")
        return eventViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let nextIndex = index + 1
        print("current: \(index)")
        print("next: \(nextIndex)")
        print(eventViewControllers.count)
        guard nextIndex > 0, eventViewControllers.count > nextIndex else {
            return nil
        }
        
        index = nextIndex
        print("load \(index)")
        return eventViewControllers[nextIndex]
    }

}

extension EventPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        eventDelegate?.eventPageViewController(self, didUpdatePageIndex: index)
    }
    
}

protocol EventPageViewControllerDelegate: class {
    /**
     Called when the number of pages is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter count: the total number of pages.
     */
    func eventPageViewController(_ eventPageViewController: EventPageViewController,
                                    didUpdatePageCount count: Int)
    
    /**
     Called when the current index is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter index: the index of the currently visible page.
     */
    func eventPageViewController(_ eventPageViewController: EventPageViewController,
                                    didUpdatePageIndex index: Int)
    
}
