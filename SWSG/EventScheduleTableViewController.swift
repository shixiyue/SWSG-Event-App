//
//  EventScheduleTableViewController.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/15/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class EventScheduleTableViewController: UITableViewController {
    var events = Events()
    
    @IBOutlet weak var eventsTableView: UITableView! {
        didSet{
            let eventItemTapGesture = UITapGestureRecognizer(target:self,action:#selector(EventScheduleTableViewController.eventItemTapHandler))
            eventItemTapGesture.numberOfTapsRequired = 1
            eventsTableView.addGestureRecognizer(eventItemTapGesture)            
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
            let event = events.retrieveEventAt(index: indexPath.item)
            if let destinationvc = self.storyboard?.instantiateViewController(withIdentifier: "EventDetailsTableViewController") as? EventDetailsTableViewController {
                EventDetailsTableViewController.event = event
                self.navigationController?.pushViewController(destinationvc, animated: true)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = self.navigationController?.isNavigationBarHidden ?? false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsTableView.tableFooterView = UIView(frame: .zero)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

    // MARK: - Table view data source
extension EventScheduleTableViewController {
    public override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.count
    }
    
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventScheduleTableViewCell
        if let event = events.retrieveEventAt(index: indexPath.item) {
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
    
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    public override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    public override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
