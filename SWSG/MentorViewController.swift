//
//  MentorViewController.swift
//  SWSG
//
//  Created by Jeremy Jee on 14/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class MentorViewController: UIViewController {
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var positionLbl: UILabel!
    @IBOutlet weak var companyLbl: UILabel!
    @IBOutlet weak var descriptionTB: UITextView!
    
    @IBOutlet weak var consultationDayList: UITableView!
    @IBOutlet weak var relatedMentorCollection: UICollectionView!
    
    public var mentor: Mentor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImg = Utility.roundUIImageView(for: profileImg)
        consultationDayList.delegate = self
        consultationDayList.dataSource = self
        
        setUpDescription()
    }
    
    func setUpDescription() {
        guard let mentor = mentor else {
            return
        }
        let profile = mentor.profile
        
        profileImg.image = profile.image
        nameLbl.text = profile.name
        positionLbl.text = profile.job
        companyLbl.text = profile.company
        descriptionTB.text = profile.desc
    }
    
    func bookSlot(on dayIndex: Int, at index: Int) {
        guard let mentor = mentor else {
            return
        }
        
        mentor.days[dayIndex].slots[index].status = .booked
        mentor.days[dayIndex].slots[index].team = System.activeUser.team
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension MentorViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let mentor = mentor else {
            return 0
        }
        
        return mentor.days.count
    }
    
    public func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let mentor = mentor else {
            return ConsultationDayCell()
        }
        
        let index = indexPath.item
        let date =  mentor.days[index]
        
        guard let cell = consultationDayList.dequeueReusableCell(withIdentifier: "consultationDayCell",
                                                      for: indexPath) as? ConsultationDayCell else {
              return ConsultationDayCell()
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "EE"
        
        cell.dayLbl.text = formatter.string(from: date.date)
        
        formatter.dateFormat = "d/MM"
        cell.dateLbl.text = formatter.string(from: date.date)
        cell.slotCollection.delegate = self
        cell.slotCollection.dataSource = self
        cell.slotCollection.tag = index
        
        return cell
    }
}

extension MentorViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
        let dayIndex = collectionView.tag
        
        guard let mentor = mentor else {
            return 0
        }
        
        let consultationSlots = mentor.days[dayIndex].slots
        
        return consultationSlots.count
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dayIndex = collectionView.tag
        
        guard let mentor = mentor, let cell = collectionView.dequeueReusableCell(
                                                            withReuseIdentifier:"consultationSlotCell",
                                                            for: indexPath) as? ConsultationSlotCell
                                                            else {
                return ConsultationSlotCell()
        }
        let consultationSlots = mentor.days[dayIndex].slots
        
        let index = indexPath.item
        let slot = consultationSlots[index]
        
        cell.setTime(to: slot.startDateTime)
        cell.setStatus(is: slot.status)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               didSelectItemAt indexPath: IndexPath){
        guard let mentor = mentor else {
            return
        }
        
        let dayIndex = collectionView.tag
        let index = indexPath.item
        let slot = mentor.days[dayIndex].slots[index]
        
        guard slot.status == .vacant else {
            return
        }
        
        let message = "Would you like to book \(slot.startDateTime.string(format: "dd/M - Ha"))?"
        let bookingController = UIAlertController(title: "Book Slot", message: message,
                                                  preferredStyle: UIAlertControllerStyle.alert)
        
        //Add an Action to Confirm the Deletion with the Destructive Style
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { _ -> Void in
            self.bookSlot(on: dayIndex, at: index)
            
            collectionView.reloadItems(at: [indexPath])
        }
        bookingController.addAction(confirmAction)
        
        //Add a Cancel Action to the Popup
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
        }
        bookingController.addAction(cancelAction)
            
        //Present the Popup
        self.present(bookingController, animated: true, completion: nil)
    }
}
