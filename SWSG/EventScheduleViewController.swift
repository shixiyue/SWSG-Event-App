//
//  EventScheduleTableViewController.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/15/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class EventScheduleViewController: UIViewController {
    var date : Date?
    var events = Events.sharedInstance()
    
    @IBOutlet weak var eventsTableView: UITableView! {
        didSet{
            let eventItemTapGesture = UITapGestureRecognizer(target:self,action:#selector(EventScheduleViewController.eventItemTapHandler))
            eventItemTapGesture.numberOfTapsRequired = 1
            let hideNavBarTapGesture = UITapGestureRecognizer(target:self,action:#selector(EventScheduleViewController.hideNavBarTapHandler))
            hideNavBarTapGesture.numberOfTapsRequired = 2
            
            eventsTableView.addGestureRecognizer(eventItemTapGesture)
            eventsTableView.addGestureRecognizer(hideNavBarTapGesture)
            
            eventsTableView.isUserInteractionEnabled = true
            
        }
        
    }
    
    @IBAction func onBackButtonPressed(_ sender: Any) {
        Utility.onBackButtonClick(tableViewController: self)
    }
    func eventItemTapHandler(recognizer: UIGestureRecognizer) {
        if recognizer.state == .ended {
            let point = recognizer.location(in: eventsTableView)
            guard let indexPath = eventsTableView.indexPathForRow(at: point) else {
                return
            }
            guard let date = date else {
                return
            }
            let event = events.retrieveEventAt(index: indexPath.item, at: date)
            if let destinationvc = self.storyboard?.instantiateViewController(withIdentifier: "EventDetailsTableViewController") as? EventDetailsTableViewController {
                EventDetailsTableViewController.event = event
                self.navigationController?.pushViewController(destinationvc, animated: true)
            }
        }
    }
    
    func hideNavBarTapHandler(recognizer: UIGestureRecognizer) {
        if recognizer.state == .ended {
            self.navigationItem.hidesBackButton = !self.navigationItem.hidesBackButton
            self.navigationController?.setNavigationBarHidden(self.navigationItem.hidesBackButton, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = self.navigationController?.isNavigationBarHidden ?? false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsTableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension EventScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let date = date, let eventRetrieved = events.retrieveEvent(at: date) else{
            return 0
        }
        return eventRetrieved.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventScheduleTableViewCell
        if let date = date, let event = events.retrieveEventAt(index: indexPath.item, at: date) {
            cell.eventName.text = event.name
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            cell.eventTimeVenue.text = timeFormatter.string(from: event.date_time) + " @ " + event.venue
            cell.eventDescription.text = event.description
        }
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
