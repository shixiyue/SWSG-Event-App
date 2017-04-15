//
//  MentorViewController.swift
//  SWSG
//
//  Created by Jeremy Jee on 14/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import Firebase

class MentorGridViewController: BaseViewController {
    @IBOutlet weak var mentorCollection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MAR: Properties
    fileprivate var insets: CGFloat!
    fileprivate var mentors = [User]()
    fileprivate var filteredMentors = [User]()
    fileprivate var searchActive = false {
        willSet(newSearchActive) {
            mentorCollection.reloadData()
        }
    }
    
    //MARK: Firebase References
    private var mentorsRef: FIRDatabaseQuery?
    private var mentorsRefHandle: FIRDatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        
        insets = self.view.frame.width * 0.01
        
        mentorCollection.delegate = self
        mentorCollection.dataSource = self
        
        mentorsRef = System.client.getMentorsRef()
        observeMentors()
        setUpSearchBar()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Config.mentorGridToMentor {
            if let mentorVC = segue.destination as? MentorViewController,
                let indexPaths = mentorCollection.indexPathsForSelectedItems {
                let index = indexPaths[0].item
                
                let mentor: User
                
                if searchActive {
                    mentor = filteredMentors[index]
                } else {
                    mentor = mentors[index]
                }
                
                mentorVC.mentorAcct = mentor
            }
        }
    }
    
    deinit {
        if let refHandle = mentorsRefHandle {
            mentorsRef?.removeObserver(withHandle: refHandle)
        }
    }
    
    // MARK: Layout methods
    private func setUpSearchBar() {
        Utility.setUpSearchBar(searchBar, viewController: self, selector: #selector(donePressed))
        Utility.styleSearchBar(searchBar)
    }
    
    func donePressed() {
        self.view.endEditing(true)
    }
    
    // MARK: Firebase related methods
    private func observeMentors() {
        // Use the observe method to listen for new
        // channels being written to the Firebase DB
        guard let mentorsRef = mentorsRef else {
            return
        }
        
        mentorsRefHandle = mentorsRef.observe(.value, with: { (snapshot) -> Void in
            self.mentors = [User]()
            for mentorData in snapshot.children {
                guard let mentorSnapshot = mentorData as? FIRDataSnapshot,
                    let mentorAcct = User(snapshot: mentorSnapshot) else {
                    continue
                }
                let uid = mentorSnapshot.key
                mentorAcct.setUid(uid: uid)
                
                Utility.getProfileImg(uid: uid, completion: { (image) in
                    mentorAcct.profile.updateImage(image: image)
                    self.mentorCollection.reloadData()
                })
                
                self.mentors.append(mentorAcct)
            }
            self.mentors = self.mentors.sorted(by: { $0.profile.name < $1.profile.name })
            self.mentorCollection.reloadData()
        })
    }
}

extension MentorGridViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
        if searchActive {
            return filteredMentors.count
        } else {
            return mentors.count
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = mentorCollection.dequeueReusableCell(withReuseIdentifier: "mentorCell",
                                                              for: indexPath) as? MentorCell else {
            return MentorCell()
        }
        
        let index = indexPath.item
        let profile: Profile
            
        if searchActive {
            profile = filteredMentors[index].profile
        } else {
            profile = mentors[index].profile
        }
        
        if profile.image != nil {
            cell.iconIV.image = profile.image
        } else {
            cell.iconIV.image = Config.placeholderImg
        }
        
        cell.iconIV = Utility.roundUIImageView(for: cell.iconIV)
        cell.nameLbl.text = profile.name
        cell.positionLbl.text = profile.job
        cell.companyLbl.text = profile.company
        
        return cell
    }
}

// MARK: UISearchResultsUpdating
extension MentorGridViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMentors = mentors.filter { mentor in
            return mentor.profile.name.lowercased().contains(searchText.lowercased())
        }
        
        Utility.setSearchActive(&searchActive, searchBar: searchBar)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        Utility.setSearchActive(&searchActive, searchBar: searchBar)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        Utility.setSearchActive(&searchActive, searchBar: searchBar)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        Utility.setSearchActive(&searchActive, searchBar: searchBar)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Utility.setSearchActive(&searchActive, searchBar: searchBar)
        Utility.searchBtnPressed(viewController: self)
    }
}
