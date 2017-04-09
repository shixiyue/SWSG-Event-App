//
//  EventDetailsTableViewController.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/16/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class EventDetailsTableViewController: UITableViewController {
    
    public var event : Event?
    private var containerHeight: CGFloat!
    private var events = Events.instance
    

    @IBOutlet weak var eventDetailsTableView: UITableView!

    @IBOutlet weak var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: Notification.Name(rawValue: "comments"), object: nil)
        /*if let comments = Storage.readComments(fileName: Config.commentsFileName) {
            Comments.comments = comments
        }*/
       // CommentsInputTableViewCell.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    private func setUpTable() {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    @IBAction func onAddCalendarBtnClicked(_ sender: Any) {
        /*guard let event = event, let date = event.startDateTime else{
            return
        }

        let startTimes = Utility.strtok(string: event.start_datetime, delimiter: ": ")
        var startDate = Calendar.current.date(byAdding: .hour, value: startTimes[0], to: date)
        startDate = Calendar.current.date(byAdding: .minute, value: startTimes[1], to: startDate!)!
        let endTimes = Utility.strtok(string: event.end_datetime, delimiter: ": ")
        var endDate = Calendar.current.date(byAdding: .hour, value: endTimes[0], to: date)
        endDate = Calendar.current.date(byAdding: .minute, value: endTimes[1], to: endDate!)

        Utility.addEventToCalendar(title: event.name, description: event.description, startDate: startDate!, endDate: endDate!)*/
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
            if let size = Comments.comments[self.event!.name]?.count {
                return size + 1
            }
            return 1
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            switch indexPath.item {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "EventTime", for: indexPath) as! EventTimeTableViewCell
               // let timeFormatter = DateFormatter()
                //timeFormatter.dateFormat = "HH:mm"
                //cell.timeLabel.text = self.event!.start_datetime
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "EventVenue", for: indexPath) as! EventVenueTableViewCell
                cell.venueLabel.text = self.event?.venue
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "EventDetail", for: indexPath) as! EventDetailTableViewCell
                cell.detailsLabel.text = self.event?.shortDesc
                return cell
            default:
                let cell = UITableViewCell()
                return cell
            }
        } else {
            if indexPath.row == Comments.comments[self.event!.name]?.count || (indexPath.row == 0 && Comments.comments[self.event!.name]?.count == nil) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsInput", for: indexPath) as! CommentsInputTableViewCell
                cell.commentInputField.delegate = self
                cell.commentInputField.setPlaceholder("Add a Comment")
                cell.selectionStyle = .none
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "Comments", for: indexPath) as! CommentsTableViewCell
            cell.commentsLabel.text = Comments.comments[self.event!.name]?[indexPath.row].words
            cell.usernameLabel.text = Comments.comments[self.event!.name]?[indexPath.row].username
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
            cell.eventHeaderLabel.text = self.event?.name
            return cell.contentView
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsHeader")
            return cell?.contentView
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "container", let containerViewController = segue.destination as? TemplateViewController else {
            return
        }
        guard let event = self.event else {
            return
        }
        containerViewController.presetInfo(desc: "", images: event.images, videoLink: "", isScrollEnabled: false)
        print("here in preparing for segue \(event.description)")
        containerViewController.tableView.layoutIfNeeded()
        containerView.frame = CGRect(x: 0, y: 0, width: tableView.contentSize.width, height: containerViewController.tableView.contentSize.height)
    }
    
}

extension EventDetailsTableViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        textView.translatesAutoresizingMaskIntoConstraints = true
        var size = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        guard size.height != textView.frame.size.height else {
            return
        }
        size.width = size.width > textView.frame.size.width ? size.width : textView.frame.size.width
        textView.frame.size = size
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard let textView = textView as? GrayBorderTextView, let currentText = textView.text else {
            return false
        }
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if updatedText.isEmpty {
            textView.setPlaceholder()
            return false
        } else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.removePlaceholder()
        }
        return true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        guard view.window != nil, textView.textColor == UIColor.lightGray else {
            return
        }
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
    }
    
}
