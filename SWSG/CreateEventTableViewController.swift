//
//  CreateEventTableViewController.swift
//  SWSG
//
//  Created by Li Xiaowei on 4/7/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//
/*
import UIKit

class CreateEventTableViewController: UITableViewController {

    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var endTime: UITextField!
    @IBOutlet weak var evntDetails: UITextView!
    @IBOutlet weak var evntLocation: UITextField!
    @IBOutlet weak var evntTitle: UITextField!
    
    @IBOutlet weak var dateField: UITextField!
    private var containerHeight: CGFloat!
    public var detailCellHeight = CGFloat(60)
    private var timeToEdit = Config.start
    private var events = Events.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        evntDetails.delegate = self
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.black
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CreateEventTableViewController.tappedCancelBarBtn))
        let okBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(CreateEventTableViewController.donePressed))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        label.font = UIFont(name: "Helvetica", size: 12)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = "Select a date"
        label.textAlignment = NSTextAlignment.center
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([cancelBtn,flexSpace,textBtn,flexSpace,okBarBtn], animated: true)
        startTime.inputAccessoryView = toolBar
        endTime.inputAccessoryView = toolBar
        dateField.inputAccessoryView = toolBar
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Name(rawValue: "reload"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addEvent), name: Notification.Name(rawValue: "update"), object: nil)
    }
    @IBAction func dateFldEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        timeToEdit = Config.date
        datePickerView.addTarget(self, action: #selector(CreateEventTableViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @IBAction func startTimeTxtFldEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.time
        sender.inputView = datePickerView
        timeToEdit = Config.start
        datePickerView.addTarget(self, action: #selector(CreateEventTableViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @IBAction func onBackBtnClicked(_ sender: Any) {
        Utility.onBackButtonClick(tableViewController: self)
    }
    
    @IBAction func endTimeTxtFldEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.time
        sender.inputView = datePickerView
        timeToEdit = Config.end
        datePickerView.addTarget(self, action: #selector(CreateEventTableViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        dateFormatter.locale = Locale.current
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH : mm "
        timeFormatter.locale = Locale.current
        
        if timeToEdit == Config.start {
        startTime.text = timeFormatter.string(from: sender.date)
        } else if timeToEdit == Config.end {
            endTime.text = timeFormatter.string(from: sender.date)
        } else if timeToEdit == Config.date {
            dateField.text = dateFormatter.string(from: sender.date)
        }
    }
    
    @objc private func addEvent(_ notification: NSNotification) {
        guard let name = evntTitle.text, !name.isEmpty, let strtTime = startTime.text, !strtTime.isEmpty, let edTime = endTime.text, !edTime.isEmpty, let ltn = evntLocation.text, !ltn.isEmpty, let ttle = evntTitle.text, !ttle.isEmpty, let details = evntDetails.text, !details.isEmpty else {
            present(Utility.getFailAlertController(message: "Required fields cannot be empty!"), animated: true, completion: nil)
            return
        }
        guard let description = notification.userInfo?["description"] as? String else {
            return
        }
        NotificationCenter.default.removeObserver(self)
        let images = (notification.userInfo?["images"] as? [UIImage]) ?? [UIImage]()
        /*events.addEvent(event: Event(images: images, name: ttle, start_datetime: strtTime, end_datetime: edTime, venue: ltn, description: description, details: details), to: Date.date(from:dateField.text!))*/
    
        Utility.onBackButtonClick(tableViewController: self)
    }

    
    func donePressed(sender: UIBarButtonItem) {
        if timeToEdit == Config.start {
        startTime.resignFirstResponder()
        } else if timeToEdit == Config.end {
        endTime.resignFirstResponder()
        } else if timeToEdit == Config.date {
            dateField.resignFirstResponder()
        }
    }
    
    func tappedCancelBarBtn(sender: UIBarButtonItem) {
        if timeToEdit == Config.start {
            startTime.resignFirstResponder()
        } else if timeToEdit == Config.end {
            endTime.resignFirstResponder()
        } else if timeToEdit == Config.date {
            dateField.resignFirstResponder()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 130
        case 1: return 130
        case 2: return 60
        case 3: return detailCellHeight
        case 4: return containerHeight
        default: return 44
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare for segue")
        guard segue.identifier == "container", let containerViewController = segue.destination as? TemplateEditViewController else {
            print("returnning")
            return
        }
        containerViewController.tableView.layoutIfNeeded()
        containerHeight = containerViewController.tableView.contentSize.height
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    @objc private func reload(_ notification: NSNotification) {
        guard let containerHeight = notification.userInfo?["height"] as? CGFloat else {
            return
        }
        self.containerHeight = containerHeight
        tableView.reloadData()
    }
    


}

extension CreateEventTableViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.tableView.beginUpdates()
        if textView.contentSize.height > CGFloat(60) {
        self.detailCellHeight = textView.contentSize.height
        }
        self.tableView.endUpdates()
        
    }
}
*/
