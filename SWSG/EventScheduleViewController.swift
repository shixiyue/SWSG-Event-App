//
//  EventScheduleTableViewController.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/15/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

//Note: Unused

import UIKit
/*
class EventScheduleViewController: UIViewController {
    var date : Date?
    var events = Events.sharedInstance()
    var delegate: EventScheduleViewControllerDelegate?
    
    @IBOutlet weak var dateLabel: UILabel!
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
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var leftBtn: UIButton!
    
    @IBAction func onLeftBtnPressed(_ sender: Any) {
        delegate?.onLeftScrollBtnPressed()
    }
    
    @IBAction func onRightBtnPressed(_ sender: Any) {
        delegate?.onRightScrollBtnPressed()
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
                destinationvc.date = self.date
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
        if let delegate = delegate, !delegate.hasNextPage() {
            rightBtn.setTitleColor(UIColor.lightGray, for: .normal)
        }
        if let delegate = delegate, !delegate.hasPrevPage() {
            leftBtn.setTitleColor(UIColor.lightGray, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsTableView.tableFooterView = UIView(frame: .zero)
        if let date = date {
            dateLabel.text = Date.toString(date: date)
            dateLabel.textColor = UIColor.red
        }
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
            // let timeFormatter = DateFormatter()
            //timeFormatter.dateFormat = "HH:mm"
            cell.eventTimeVenue.text = event.start_datetime + "-" + event.end_datetime + " @ " + event.venue
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
    
}*/
