//
//  EventListPageViewController.swift
//  SWSG
//
//  Created by Li Xiaowei on 4/5/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

//Note: Unused
/*
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
        controller.delegate = self
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

extension EventListPageViewController: EventScheduleViewControllerDelegate {
    func onLeftScrollBtnPressed() {
        if let date = currentDate, let prevDate = Calendar.current.date(byAdding: .day, value: -1, to: date), events.contains(date: Date.date(from: Date.toString(date: prevDate))) {
            currentDate = prevDate
            print("\(currentDate) after scroll before")
            let viewController = nextEventViewController(date: Date.date(from: Date.toString(date: currentDate!)))
            setViewControllers([viewController],
                               direction: .reverse,
                               animated: true,
                               completion: nil)
        }
    }
    func onRightScrollBtnPressed() {
        if let date = currentDate, let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: date), events.contains(date: Date.date(from: Date.toString(date: nextDate))) {
            currentDate = nextDate
            print("\(currentDate) after scroll before")
            let viewController = nextEventViewController(date: Date.date(from: Date.toString(date: currentDate!)))
            setViewControllers([viewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
    }
    func hasNextPage() -> Bool {
        if let date = currentDate, let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: date), events.contains(date: Date.date(from: Date.toString(date: nextDate))) {
            return true
        }
        return false
    }
    func hasPrevPage() -> Bool {
        if let date = currentDate, let prevDate = Calendar.current.date(byAdding: .day, value: -1, to: date), events.contains(date: Date.date(from: Date.toString(date: prevDate))) {
            return true
        }
        return false
    }
}

protocol EventScheduleViewControllerDelegate: class {
    func onLeftScrollBtnPressed()
    func onRightScrollBtnPressed()
    func hasNextPage() -> Bool
    func hasPrevPage() -> Bool
}*/

