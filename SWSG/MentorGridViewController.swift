//
//  MentorViewController.swift
//  SWSG
//
//  Created by Jeremy Jee on 14/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class MentorGridViewController: BaseViewController {
    @IBOutlet weak var mentorCollection: UICollectionView!
    
    fileprivate var insets: CGFloat!
    fileprivate var mentors = [User]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        System.createSampleMentors()
        System.client.getMentors(completion: { (users, error) in
            self.mentors = users
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        
        insets = self.view.frame.width * 0.01
        
        mentorCollection.delegate = self
        mentorCollection.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mentorCollection.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chosenMentor" {
            let navController = segue.destination as! UINavigationController
            let mentorVC = navController.viewControllers[0] as! MentorViewController
            
            if let indexPaths = mentorCollection.indexPathsForSelectedItems {
                let index = indexPaths[0].item
                mentorVC.mentorAcct = mentors[index]
            }
        }
    }
}

extension MentorGridViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
        return mentors.count
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("test")
        guard let cell = mentorCollection.dequeueReusableCell(withReuseIdentifier: "mentorCell",
                                                              for: indexPath) as? MentorCell else {
            return MentorCell()
        }
        print("test")
        
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

