//
//  CreateEventTableViewController.swift
//  SWSG
//
//  Created by Li Xiaowei on 4/7/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class CreateEventTableViewController: UITableViewController {

    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var endTime: UITextField!
    
    private var containerHeight: CGFloat!
    
    private var timeToEdit = Config.start
    @IBAction func startTimeTxtFldEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        sender.inputView = datePickerView
        timeToEdit = Config.start
        datePickerView.addTarget(self, action: #selector(CreateEventTableViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    @IBAction func onBackBtnClicked(_ sender: Any) {
        Utility.onBackButtonClick(tableViewController: self)
    }
    @IBAction func endTimeTxtFldEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        sender.inputView = datePickerView
        timeToEdit = Config.end
        datePickerView.addTarget(self, action: #selector(CreateEventTableViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.medium
        if timeToEdit == Config.start {
        startTime.text = dateFormatter.string(from: sender.date)
        } else if timeToEdit == Config.end {
            endTime.text = dateFormatter.string(from: sender.date)
        }
        print("\(sender.target(forAction:  #selector(CreateEventTableViewController.datePickerValueChanged), withSender: sender))")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Name(rawValue: "reload"), object: nil)
    }
    
    func donePressed(sender: UIBarButtonItem) {
        if timeToEdit == Config.start {
        startTime.resignFirstResponder()
        } else if timeToEdit == Config.end {
        endTime.resignFirstResponder()
        }
    }
    
    func tappedCancelBarBtn(sender: UIBarButtonItem) {
        if timeToEdit == Config.start {
            startTime.resignFirstResponder()
        } else if timeToEdit == Config.end {
            endTime.resignFirstResponder()
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
        case 3: return 60
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
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
