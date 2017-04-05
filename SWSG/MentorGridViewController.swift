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
    
    fileprivate var insets: CGFloat!
    fileprivate var mentors = [User]()
    
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Config.mentorGridToMentor {
            let mentorVC = segue.destination as! MentorViewController
            
            if let indexPaths = mentorCollection.indexPathsForSelectedItems {
                let index = indexPaths[0].item
                mentorVC.mentorAcct = mentors[index]
            }
        }
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
                
                mentorAcct.setUid(uid: mentorSnapshot.key)
                System.client.fetchProfileImage(for: mentorSnapshot.key, completion: { (image) in
                    mentorAcct.profile.updateImage(image: image)
                    self.mentorCollection.reloadData()
                })
                self.mentors.append(mentorAcct)
            }
            self.mentorCollection.reloadData()
        })
    }
}

extension MentorGridViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
        return mentors.count
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = mentorCollection.dequeueReusableCell(withReuseIdentifier: "mentorCell",
                                                              for: indexPath) as? MentorCell else {
            return MentorCell()
        }
        
        let index = indexPath.item
        let profile = mentors[index].profile
        
        cell.iconIV.image = profile.image
        cell.iconIV = Utility.roundUIImageView(for: cell.iconIV)
        cell.nameLbl.text = profile.name
        cell.positionLbl.text = profile.job
        cell.companyLbl.text = profile.company
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MentorGridViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = self.view.frame.width
        let widthPerItem = (availableWidth / 2) - insets - insets
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return insets
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return insets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: insets, bottom: 0, right: insets)
    }
}

