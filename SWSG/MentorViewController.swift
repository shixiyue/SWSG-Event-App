//
//  MentorViewController.swift
//  SWSG
//
//  Created by Jeremy Jee on 14/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import Firebase

/**
 MentorViewController is a UIViewController used to details for a Mentor.
 
 Specifications:
    - mentorAcct: Mentor whose account to display
 */
class MentorViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var positionLbl: UILabel!
    @IBOutlet weak var companyLbl: UILabel!
    @IBOutlet weak var descriptionTB: UITextView!
    @IBOutlet weak var mentorView: UIView!
    @IBOutlet weak var consultationSlotCollection: UICollectionView!
    @IBOutlet weak var relatedMentorCollection: UICollectionView!
    
    // MARK: Properties
    public var mentorAcct: User?
    fileprivate var relatedMentors = [User]()
    fileprivate var cvLayout = MultiDirectionCollectionViewLayout()
    private let mentorBookingErrorMsg = "Sorry, only participants of SWSG can book a slot!"
    
    // MARK: Firebase References
    private var mentorRef: FIRDatabaseReference!
    private var mentorRefHandle: FIRDatabaseHandle?
    
    //MARK: Initialization Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCollections()
        setUpView()
        setUpDescription()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        observeSlots()
        getRelatedMentors()
    }
    
    private func setUpCollections() {
        consultationSlotCollection.delegate = self
        consultationSlotCollection.dataSource = self
        consultationSlotCollection.collectionViewLayout = cvLayout
        
        relatedMentorCollection.delegate = self
        relatedMentorCollection.dataSource = self
    }
    
    private func setUpView() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToProfile))
        mentorView.addGestureRecognizer(tapGesture)
        
        guard let mentorAcct = mentorAcct, let uid = mentorAcct.uid else {
            return
        }
        
        mentorRef = System.client.getUserRef(for: uid)
        
    }
    
    private func setUpDescription() {
        guard let mentorAcct = mentorAcct, let uid = mentorAcct.uid else {
            return
        }
        let profile = mentorAcct.profile
        
        nameLbl.text = profile.name
        
        profileImg = Utility.roundUIImageView(for: profileImg)
        profileImg.image = Config.placeholderImg
        
        Utility.getProfileImg(uid: uid, completion: { (image) in
            if let image = image {
                self.profileImg.image = image
            }
        })
        
        positionLbl.text = profile.job
        companyLbl.text = profile.company
        descriptionTB.text = profile.desc
    }
    
    private func getRelatedMentors() {
        System.client.getMentors(completion: { (mentors, _) in
            self.relatedMentors = [User]()
            
            for mentorAcct in mentors {
                if self.mentorAcct?.mentor?.field == mentorAcct.mentor?.field &&
                    self.mentorAcct?.uid != mentorAcct.uid,
                    let uid = mentorAcct.uid {
                    
                    Utility.getProfileImg(uid: uid, completion: { (image) in
                        mentorAcct.profile.updateImage(image: image)
                        self.relatedMentorCollection.reloadData()
                    })
                    self.relatedMentors.append(mentorAcct)
                }
            }
            
            self.relatedMentorCollection.reloadData()
        })
    }
    
    deinit {
        if let refHandle = mentorRefHandle {
            mentorRef.removeObserver(withHandle: refHandle)
        }
    }
    
    // MARK: Firebase related methods
    private func observeSlots() {
        // Use the observe method to listen for new
        // channels being written to the Firebase DB
        mentorRefHandle = mentorRef.observe(.value, with: { (snapshot) -> Void in
            guard let userSnapshot = snapshot.value as? [String: Any],
                let mentorSnapshot = userSnapshot[Config.mentor] as? [String: Any],
                let mentor = Mentor(snapshot: mentorSnapshot) else {
                    return
            }
            self.mentorAcct?.setMentor(mentor: mentor)
            self.cvLayout.dataSourceDidUpdate = true
            self.consultationSlotCollection.reloadData()
        })
    }
    
    // MARK: Booking Function
    fileprivate func setSlot(on dayIndex: Int, at index: Int, status: ConsultationSlotStatus) {
        guard System.client.isConnected else {
            present(Utility.getNoInternetAlertController(), animated: true, completion: nil)
            return
        }
        
        guard let mentorAcct = mentorAcct, let mentor = mentorAcct.mentor else {
            return
        }
        
        let day = mentor.days[dayIndex]
        let dateString = Utility.fbDateFormatter.string(from: day.date)
        let slot = day.slots[index]
        let slotTimeString = Utility.fbDateTimeFormatter.string(from: slot.startDateTime)
        
        let slotRef = mentorRef.child("\(Config.mentor)/\(Config.consultationDays)/\(dateString)/\(slotTimeString)")
        slotRef.child(Config.consultationStatus).setValue(status.rawValue)
        
        if status == .booked {
            slotRef.child(Config.team).setValue(System.activeUser?.team)
            mentor.days[dayIndex].slots[index].team = System.activeUser?.team
        }
        mentor.days[dayIndex].slots[index].status = status
    }
    
    // MARK: User Interaction Functions
    @IBAction func composeBtnPressed(_ sender: Any) {
        
        guard let uid = System.client.getUid() else {
            Utility.logOutUser(currentViewController: self)
            return
        }
        
        guard let mentorAcct = mentorAcct, let mentorID = mentorAcct.uid else {
            return
        }
        
        var members = [String]()
        members.append(uid)
        members.append(mentorID)
        
        let channel = Channel(type: .directMessage, members: members)
        System.client.createChannel(for: channel, completion: { (channel, error) in
            guard error == nil else {
                return
            }
            self.performSegue(withIdentifier: Config.mentorToChat, sender: channel)
        })
    }
    
    // MARK: Navigation
    func goToProfile(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: Config.mentorToProfile, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == Config.mentorToChat, let channel = sender as? Channel {
            guard let chatVc = segue.destination as? ChannelViewController else {
                return
            }
            
            chatVc.senderDisplayName = System.activeUser?.profile.username
            chatVc.channel = channel
        } else if segue.identifier == Config.mentorToRelatedMentor,
            let mentorVC = segue.destination as? MentorViewController {
            if let indexPaths = relatedMentorCollection.indexPathsForSelectedItems {
                let index = indexPaths[0].item
                mentorVC.mentorAcct = relatedMentors[index]
            }
        } else if segue.identifier == Config.mentorToProfile,
            let profileVC = segue.destination as? ProfileViewController,
            let mentorAcct = mentorAcct {
            profileVC.user = mentorAcct
        } else if segue.identifier == Config.mentorToTeamInfo, let team = sender as? Team,
            let teamInfoVC = segue.destination as? TeamInfoTableViewController {
            teamInfoVC.team = team
        }
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension MentorViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let mentorAcct = mentorAcct, let mentor = mentorAcct.mentor else {
                return 1
        }
        
        if collectionView.tag == Config.slotCollectionTag {
            return mentor.days.count
        } else {
            return 1
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
        guard let mentorAcct = mentorAcct, let mentor = mentorAcct.mentor else {
            return 0
        }
        
        if collectionView.tag == Config.slotCollectionTag {
            return mentor.days[section].slots.count + 1
        } else if collectionView.tag == Config.relatedCollectionTag {
            return relatedMentors.count
        } else {
            return 0
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == Config.slotCollectionTag && indexPath.item == 0 {
            return getConsultationDayCell(for: collectionView, at: indexPath)
        } else if collectionView.tag == Config.slotCollectionTag {
            return getConsultationSlotCell(for: collectionView, at: indexPath)
        } else if collectionView.tag == Config.relatedCollectionTag {
            return getRelatedMentorCell(for: collectionView, at: indexPath)
        } else {
            return UICollectionViewCell()
        }
    }
    
    private func getConsultationDayCell(for collectionView: UICollectionView,
                                      at indexPath: IndexPath) -> UICollectionViewCell {
        guard let mentorAcct = mentorAcct, let mentor = mentorAcct.mentor,
            let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier:"consultationDayCell",
            for: indexPath) as? ConsultationDayCell
            else {
                return ConsultationDayCell()
        }
        
        let date = mentor.days[indexPath.section].date
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "EE"
        
        cell.dayLbl.text = formatter.string(from: date)
        
        formatter.dateFormat = "d/MM"
        cell.dateLbl.text = formatter.string(from: date)
        
        return cell
    }
    
    private func getConsultationSlotCell(for collectionView: UICollectionView,
                                         at indexPath: IndexPath) -> UICollectionViewCell {
        guard let mentorAcct = mentorAcct, let mentor = mentorAcct.mentor,
            let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Config.consultationSlotCell,
            for: indexPath) as? ConsultationSlotCell
            else {
                return ConsultationSlotCell()
        }
        let consultationSlots = mentor.days[indexPath.section].slots
        let slot = consultationSlots[indexPath.item - 1]
        
        cell.setTime(to: slot.startDateTime)
        cell.setStatus(is: slot.status)
        
        return cell
    }
    
    private func getRelatedMentorCell(for collectionView: UICollectionView,
                                      at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            Config.relatedMentorCell, for: indexPath) as? MentorCell else {
                return MentorCell()
        }
        
        let profile = relatedMentors[indexPath.item].profile
        
        cell.iconIV.image = Config.placeholderImg
        
        if let img = profile.image {
            cell.iconIV.image = img
        }
        
        cell.iconIV = Utility.roundUIImageView(for: cell.iconIV)
        cell.nameLbl.text = profile.name
        cell.positionLbl.text = profile.job
        cell.companyLbl.text = profile.company
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               didSelectItemAt indexPath: IndexPath){
        if collectionView.tag == Config.slotCollectionTag && indexPath.item > 0 {
            selectedSlot(for: collectionView, at: indexPath)
        } 
    }
    
    private func selectedSlot(for collectionView: UICollectionView,
                              at indexPath: IndexPath) {
        
        guard let mentor = mentorAcct?.mentor else {
            return
        }
        
        let dayIndex = indexPath.section
        let index = indexPath.item - 1
        let slot = mentor.days[dayIndex].slots[index]
        
        if System.activeUser?.uid == mentorAcct?.uid, slot.status == .booked, let team = slot.team {
            System.client.getTeam(with: team, completion: { (team, _) in
                if let team = team {
                    let title = "\(slot.startDateTime.string(format: "dd/M - Ha"))"
                    let message = "Has been booked by \(team.name)"
                    let slotController = UIAlertController(title: title, message: message,
                                                              preferredStyle: UIAlertControllerStyle.alert)
                                        
                    let dismissAction = UIAlertAction(title: "Dismiss", style: .default) { _ in
                    }
                    slotController.addAction(dismissAction)
                    
                    let viewAction = UIAlertAction(title: "View Profile", style: .default) { _ in
                        self.performSegue(withIdentifier: Config.mentorToTeamInfo, sender: team)
                    }
                    slotController.addAction(viewAction)
                    
                    //Present the Popup
                    self.present(slotController, animated: true, completion: nil)
                    return
                }
            })
            return
        } else if System.activeUser?.uid == mentorAcct?.uid {
            let title = "Slot Status"
            let message = "Set Slot Status"
            let slotController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            if slot.status != .vacant {
                let availableAction = UIAlertAction(title: "Vacant", style: .default,
                                                    handler: { _ in
                    self.setSlot(on: dayIndex, at: index, status: .vacant)
                    return
                })
                slotController.addAction(availableAction)
            }
            
            if slot.status != .unavailable {
                let unavailableAction = UIAlertAction(title: "Unavailable", style: .default,
                                                      handler: { _ in
                    self.setSlot(on: dayIndex, at: index, status: .unavailable)
                    return
                })
                slotController.addAction(unavailableAction)
            }
            
            //Add a Cancel Action to the Popup
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                return
            }
            slotController.addAction(cancelAction)
            
            slotController.popoverPresentationController?.sourceView = self.view
            
            //Displays the Compose Popup
            self.present(slotController, animated: true, completion: nil)
        }
        
        guard System.activeUser?.type.isParticipant == true, System.activeUser?.team != Config.noTeam else {
            let title = "Error"
            let message = "You need to be part of a team to book a slot"
            Utility.displayDismissivePopup(title: title, message: message, viewController: self, completion: { _ in
            })
            return
        }
        
        guard slot.status == .vacant else {
            return
        }
        
        let message = "Would you like to book \(slot.startDateTime.string(format: "dd/M - Ha"))?"
        let bookingController = UIAlertController(title: "Book Slot", message: message,
                                                  preferredStyle: UIAlertControllerStyle.alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { _ -> Void in
            self.setSlot(on: dayIndex, at: index, status: .booked)
        }
        bookingController.addAction(confirmAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
        }
        bookingController.addAction(cancelAction)
        
        self.present(bookingController, animated: true, completion: nil)
    }
}
