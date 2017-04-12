//
//  ProfileListViewController.swift
//  SWSG
//
//  Created by Jeremy Jee on 10/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import Firebase

class ProfileListViewController: BaseViewController {
    
    @IBOutlet weak var profileList: UITableView!
    
    fileprivate let client = System.client
    fileprivate var users = [User]()
    
    fileprivate var favouritesRef: FIRDatabaseReference?
    private var favouritesAddedHandle: FIRDatabaseHandle?
    private var favouritesRemovedHandle: FIRDatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSlideMenuButton()
        observeFavourites()
        
        profileList.delegate = self
        profileList.dataSource = self
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == Config.profileListToProfile, let user = sender as? User {
            guard let profileVC = segue.destination as? ProfileViewController else {
                return
            }
            
            profileVC.user = user
        }
    }
    
    // MARK: Firebase related methods
    private func observeFavourites() {
        guard let uid = System.activeUser?.uid else {
            return
        }
        
        favouritesRef = System.client.getUserRef(for: uid).child(Config.favourites)
        favouritesAddedHandle = favouritesRef?.observe(.childAdded, with: { (snapshot) in
            guard let uid = snapshot.value as? String else {
                return
            }
            
            System.client.getUserWith(uid: uid, completion: { (user, error) in
                if let user = user {
                    self.users.append(user)
                    self.profileList.reloadData()
                }
            })
        })
        
        favouritesRemovedHandle = favouritesRef?.observe(.childRemoved, with: { (snapshot) in
            guard let uid = snapshot.value as? String else {
                return
            }
            
            for (index, user) in self.users.enumerated() {
                if user.uid == uid {
                    self.users.remove(at: index)
                    self.profileList.reloadData()
                    return
                }
            }
        })
    }
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        displaySearch(existingText: "")
    }
    
    private func displaySearch(existingText: String) {
        let message = "Enter Username of Individual"
        let title = "Profile Search"
        let btnText = "Search"
        let placeholder = "Username"
        Utility.createPopUpWithTextField(title: title, message: message,
                                         btnText: btnText, placeholderText: placeholder,
                                         existingText: existingText,
                                         viewController: self,
                                         completion: { (username) in
                                            self.searchForUser  (username: username)
        })
    }
    
    func searchForUser(username: String?) {
        guard let username = username else {
            return
        }
        
        client.getUserWith(username: username, completion: { (user, error) in
            guard let user = user else {
                Utility.displayDismissivePopup(title: "Error",
                                               message: "Username does not exist!",
                                               viewController: self, completion: { _ in })
                return
            }
            
            self.performSegue(withIdentifier: Config.profileListToProfile, sender: user)
        })
    }
}

// MARK: UITableViewDataSource
extension ProfileListViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    public func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.item]
        guard let uid = user.uid, let cell = tableView.dequeueReusableCell(
            withIdentifier: Config.profileCell, for: indexPath) as? ProfileCell else {
                return ProfileCell()
        }
        
        cell.colorBorder.backgroundColor = Config.themeColor
        cell.iconIV = Utility.roundUIImageView(for: cell.iconIV)
        cell.iconIV.image = Config.placeholderImg
        cell.nameLbl.text = user.profile.name
        cell.jobLbl.text = user.profile.job
        cell.companyLbl.text = user.profile.company
        
        Utility.getTeamLbl(user: user, completion: { (teamLblText) in
            cell.teamLbl.text = teamLblText
        })
        
        Utility.getProfileImg(uid: uid, completion: { (image) in
            if let image = image {
                cell.iconIV.image = image
            }
        })
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension ProfileListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.item]
        self.performSegue(withIdentifier: Config.profileListToProfile, sender: user)
    }
}

// MARK: UITextFieldDelegate
extension ProfileListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
