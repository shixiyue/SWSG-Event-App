//
//  EventDetailsTableViewController.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/16/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class EventDetailsTableViewController: UITableViewController {
    
    var event : Event?

    
    
    @IBOutlet weak var eventDetailsTableView: UITableView! {
        didSet{
            let hideNavBarTapGesture = UITapGestureRecognizer(target:self,action:#selector(EventScheduleTableViewController.hideNavBarTapHandler))
            hideNavBarTapGesture.numberOfTapsRequired = 2
            eventDetailsTableView.addGestureRecognizer(hideNavBarTapGesture)
            eventDetailsTableView.isUserInteractionEnabled = true
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
         NotificationCenter.default.addObserver(self, selector: #selector(EventDetailsTableViewController.update), name: Notification.Name(rawValue: "comments"), object: nil)
       // CommentsInputTableViewCell.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    func update() {
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideNavBarTapHandler(recognizer: UIGestureRecognizer) {
        if recognizer.state == .ended {
            self.navigationItem.hidesBackButton = !self.navigationItem.hidesBackButton
            self.navigationController?.setNavigationBarHidden(self.navigationItem.hidesBackButton, animated: true)
        }
    }
    
   
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 5
        } else {
            return Comments.comments.count+1
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            switch indexPath.item {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "EventImage", for: indexPath)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "EventTime", for: indexPath) as! EventTimeTableViewCell
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm"
                cell.timeLabel.text = timeFormatter.string(from: event!.date_time)
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "EventVenue", for: indexPath) as! EventVenueTableViewCell
                cell.venueLabel.text = event?.venue
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "EventDetail", for: indexPath) as! EventDetailTableViewCell
                cell.detailsLabel.text = event?.details
                return cell
            default:
                let cell = UITableViewCell()
                return cell
            }
        } else {
            if indexPath.row == Comments.comments.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsInput", for: indexPath) as! CommentsInputTableViewCell
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "Comments", for: indexPath) as! CommentsTableViewCell
            cell.commentsLabel.text = Comments.comments[indexPath.row].words
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventHeader") as! EventHeaderTableViewCell
            cell.eventHeaderLabel.text = event?.name
            return cell.contentView
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsHeader")
            return cell?.contentView
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
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
