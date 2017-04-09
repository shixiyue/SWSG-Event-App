//
//  EventCalendarViewController.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/27/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import JTAppleCalendar

class EventCalendarViewController: BaseViewController {
    
    // We cache our colors because we do not want to be creating
    // a new color every time a cell is displayed. We do not want a laggy
    // scrolling calendar.

    var events = Events.sharedInstance()
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSlideMenuButton()
        
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.registerCellViewXib(file: "CalendarCellView") // Registering your cell is manditory
        
        calendarView.cellInset = CGPoint(x: 0, y: 0)
        calendarView.scrollingMode = .stopAtEachCalendarFrameWidth
        calendarView.registerHeaderView(xibFileNames: ["PinkSectionHeaderView"])
        
        calendarView.selectDates([Date.init()])
 
        view.isUserInteractionEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Name(rawValue: "reload"), object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Name(rawValue: "events"), object: nil)
        // Do any additional setup after loading the view.

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        } else {
            cell.selectedView.isHidden = true
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
        //cell.dot.layer.cornerRadius = cell.frame.width / 2
        
        if events.contains(date: Date.date(from: Date.toString(date: date))) {
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
/*
        let storyboard = UIStoryboard(name: Config.eventSystem, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EventListPageViewController") as? EventListPageViewController
        if events.contains(date: date), let controller = controller {
            controller.startDate = Date.date(from: Date.toString(date: date))
            self.navigationController?.pushViewController(controller, animated: true)
        }
*/
      
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

