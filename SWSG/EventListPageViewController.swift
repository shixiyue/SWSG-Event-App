//
//  EventListPageViewController.swift
//  SWSG
//
//  Created by Li Xiaowei on 4/5/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class EventListPageViewController: UIPageViewController {
    
    var startDate: Date?
    var currentDate: Date?
    var events = Events.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        if let date = startDate {
            print("start date is \(date))")
            let firstViewController = nextEventViewController(date: date)
            currentDate = date
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
    
    func nextEventViewController(date: Date) -> UIViewController {
        let controller = UIStoryboard(name: Config.eventSystem, bundle: nil).instantiateViewController(withIdentifier: "EventScheduleViewController") as! EventScheduleViewController
        controller.date = date
        return controller
    }
}

// MARK: UIPageViewControllerDataSource

extension EventListPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let date = currentDate, let prevDate = Calendar.current.date(byAdding: .day, value: -1, to: date), events.contains(date: Date.date(from: Date.toString(date: prevDate))) else {
            //print("nil returned, \(events.contains(date: Date.date(from: Date.toString(date: Calendar.current.date(byAdding: .day, value: -1, to: currentDate!)!))))")
            return nil
        }
        currentDate = prevDate
        print("\(currentDate) after scroll before")
        return nextEventViewController(date: Date.date(from: Date.toString(date: currentDate!)))
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let date = currentDate, let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: date), events.contains(date: Date.date(from: Date.toString(date: nextDate))) else {
           //  print("nil returned, \(events.contains(date: Date.date(from: Date.toString(date: Calendar.current.date(byAdding: .day, value: 1, to: currentDate!)!))))")
            return nil
        }
        currentDate = nextDate
        print("\(currentDate) after scroll after")
        return nextEventViewController(date: Date.date(from: Date.toString(date: currentDate!)))
    }
}

