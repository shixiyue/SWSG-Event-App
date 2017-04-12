//
//  EventCalendarViewController.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/27/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import Firebase
import JTAppleCalendar

class EventCalendarViewController: BaseViewController {
    
    // We cache our colors because we do not want to be creating
    // a new color every time a cell is displayed. We do not want a laggy
    // scrolling calendar.

    var events = [Date: [Event]]()
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var dayList: UITableView!
    
    //MARK: Firebase References
    private var eventRef: FIRDatabaseReference!
    private var eventAddedHandle: FIRDatabaseHandle?
    private var eventChangedHandle: FIRDatabaseHandle?
    private var eventDeletedHandle: FIRDatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSlideMenuButton()
        
        setUpCalendar()
        setUpDayList()
        addObservers()
        observeEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendarView.reloadData()
        dayList.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dayList.reloadData()
    }
    
    private func setUpCalendar() {
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.registerCellViewXib(file: "CalendarCellView") // Registering your cell is manditory
        
        calendarView.cellInset = CGPoint(x: 0, y: 0)
        calendarView.scrollingMode = .stopAtEachCalendarFrameWidth
        calendarView.registerHeaderView(xibFileNames: ["PinkSectionHeaderView"])
        
        calendarView.scrollToDate(Date.init(), triggerScrollToDateDelegate: false)
        calendarView.selectDates([Date.init()])
    }
    
    private func setUpDayList() {
        dayList.delegate = self
        dayList.dataSource = self
    }
    
    private func addObservers() {
        view.isUserInteractionEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Name(rawValue: "reload"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Name(rawValue: "events"), object: nil)
    }
    
    // Function to handle the text color of the calendar
    func handleCellTextColor(view: JTAppleDayCellView?, cellState: CellState) {
        
        guard let myCustomCell = view as? CalendarCell  else {
            return
        }
        
        if cellState.isSelected {
            myCustomCell.dayLabel.textColor = UIColor.white
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                myCustomCell.dayLabel.textColor = UIColor.black
            } else {
                myCustomCell.dayLabel.textColor = UIColor.darkGray
            }
        }
    }
    
    @objc private func reload() {
        calendarView.reloadData()
    }
    
    // Function to handle the calendar selection
    func handleCellSelection(view: JTAppleDayCellView?, cellState: CellState) {
        guard let cell = view as? CalendarCell  else {
            return
        }
        if cellState.isSelected {
            cell.selectedView.layer.cornerRadius = 25
            cell.selectedView.isHidden = false
            cell.dot.backgroundColor = UIColor.white
        } else {
            cell.selectedView.isHidden = true
            cell.dot.backgroundColor = Config.themeColor
        }
    }
    
    // MARK: Firebase related methods
    private func observeEvents() {
        // Use the observe method to listen for new
        // channels being written to the Firebase DB
        eventRef = System.client.getEventsRef()
        eventAddedHandle = eventRef.observe(.childAdded, with: { (snapshot) -> Void in
            print(snapshot)
            guard let date = Utility.fbDateFormatter.date(from: snapshot.key) else {
                return
            }
            self.events[date] = System.client.getEvents(snapshot: snapshot)?.sorted(by: { $0.startDateTime < $1.startDateTime} )
            self.calendarView.reloadData()
        })
        
        eventChangedHandle = eventRef.observe(.childChanged, with: { (snapshot) -> Void in
            print(snapshot)
            guard let date = Utility.fbDateFormatter.date(from: snapshot.key) else {
                return
            }
            self.events[date] = System.client.getEvents(snapshot: snapshot)?.sorted(by: { $0.startDateTime < $1.startDateTime} )
            self.calendarView.reloadData()
        })
        
        eventDeletedHandle = eventRef.observe(.childRemoved, with: { (snapshot) -> Void in
            guard let date = Utility.fbDateFormatter.date(from: snapshot.key) else {
                return
            }
            self.events[date] = nil
            self.calendarView.reloadData()
        })
        
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == Config.showEventDetails, let event = sender as? Event {
            guard let detailsVC = segue.destination as? EventDetailsTableViewController else {
                    return
            }
            
            detailsVC.event = event
        }
    }

}

extension EventCalendarViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let parameters = ConfigurationParameters(startDate: Config.calendarStartDate,
                                                 endDate: Config.calendarEndDate,
                                                 numberOfRows: 6, // Only 1, 2, 3, & 6 are allowed
            calendar: Calendar.current,
            generateInDates: .forAllMonths,
            generateOutDates: .tillEndOfRow,
            firstDayOfWeek: .monday)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        guard let cell = cell as? CalendarCell else {
            return
        }
        
        // Setup Cell text
        cell.dayLabel.text = cellState.text
        cell.dot.layer.cornerRadius = 5
        cell.dot.backgroundColor = Config.themeColor
        //cell.dot.layer.cornerRadius = cell.frame.width / 2
        if events.keys.contains(date) {
            cell.dot.isHidden = false
        } else {
            //  print("does not contain date \(Date.date(from: Date.toString(date: date)))")
            cell.dot.isHidden = true
        }
        
        handleCellTextColor(view: cell, cellState: cellState)
        handleCellSelection(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
        dayList.reloadData()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    // This sets the height of your header
    func calendar(_ calendar: JTAppleCalendarView, sectionHeaderSizeFor range: (start: Date, end: Date), belongingTo month: Int) -> CGSize {
        return CGSize(width: 200, height: 70)
    }
    
    // This setups the display of your header
    func calendar(_ calendar: JTAppleCalendarView, willDisplaySectionHeader header: JTAppleHeaderView, range: (start: Date, end: Date), identifier: String) {
        let headerCell = (header as? CalendarHeaderView)
        let month = Calendar.current.dateComponents([.month], from: range.start).month!
        let monthName = DateFormatter().monthSymbols[(month-1) % 12]
        let year = Calendar.current.component(.year, from: range.start)
        headerCell?.title.text = monthName + " " + String(year)
    }
}

// MARK: UITableViewDataSource
extension EventCalendarViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let selectedDate = calendarView.selectedDates.first,
            events.keys.contains(selectedDate),
            let eventList = events[selectedDate] else {
            return 0
        }
        
        return eventList.count
    }
    
    public func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Config.eventCell, for: indexPath) as? EventScheduleTableViewCell,
            let selectedDate = calendarView.selectedDates.first,
            events.keys.contains(selectedDate),
            let eventList = events[selectedDate] else {
                return EventScheduleTableViewCell()
        }
        
        let event = eventList[indexPath.item]
        
        guard let id = event.id else {
            return EventScheduleTableViewCell()
            
        }
        
        cell.colorBorder.backgroundColor = Config.themeColor
        cell.eventName.text = event.name
        
        cell.eventIV.isHidden = true
        
        Utility.getEventIcon(id: id, completion: { (image) in
            guard let image = image else {
                return
            }
            
            eventList[indexPath.item].image = image
            cell.eventIV.image = image
            cell.eventIV.isHidden = false
            
        })
        
        let formatter = Utility.fbTimeFormatter
        let startTimeString = formatter.string(from: event.startDateTime)
        let endTimeString = formatter.string(from: event.endDateTime)
        cell.eventTime.text = "\(startTimeString) - \(endTimeString)"
        cell.venue.text = "@ \(event.venue)"
        cell.eventDescription.text = event.shortDesc
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension EventCalendarViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedDate = calendarView.selectedDates.first,
            events.keys.contains(selectedDate),
            let eventsList = events[selectedDate] else {
                return
        }
        let event = eventsList[indexPath.item]
        
        self.performSegue(withIdentifier: Config.showEventDetails, sender: event)
    }
}

