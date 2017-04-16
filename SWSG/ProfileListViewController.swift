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
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var headerLbl: UILabel!
    
    fileprivate let client = System.client
    fileprivate var favourites = [User]()
    fileprivate var users = [User]()
    fileprivate var filteredUsers = [User]()
    fileprivate var searchActive = false {
        willSet(newSearchActive) {
            if newSearchActive {
                headerLbl.text = Config.headerSearchResults
            } else {
                headerLbl.text = Config.headerFavourites
            }
            
            profileList.reloadData()
        }
    }
    
    fileprivate var favouritesRef: FIRDatabaseReference?
    private var favouritesAddedHandle: FIRDatabaseHandle?
    private var favouritesRemovedHandle: FIRDatabaseHandle?
    
    fileprivate var usersRef: FIRDatabaseReference?
    private var usersAddedHandle: FIRDatabaseHandle?
    private var usersRemovedHandle: FIRDatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSlideMenuButton()
        setUpSearchBar()
        setUpTable()
        observeFavourites()
        observeUsers()
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == Config.profileListToProfile, let user = sender as? User else {
            return
        }
        guard let profileVC = segue.destination as? ProfileViewController else {
            return
        }
            
        profileVC.user = user
    }
    
    // MARK: Layout methods
    private func setUpSearchBar() {
        Utility.setUpSearchBar(searchBar, viewController: self, selector: #selector(donePressed))
        Utility.styleSearchBar(searchBar)
    }
    
    func donePressed() {
        self.view.endEditing(true)
    }
    
    private func setUpTable() {
        profileList.delegate = self
        profileList.dataSource = self
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
                    self.favourites.append(user)
                    self.profileList.reloadData()
                }
            })
        })
        
        favouritesRemovedHandle = favouritesRef?.observe(.childRemoved, with: { (snapshot) in
            guard let uid = snapshot.value as? String else {
                return
            }
            
            for (index, user) in self.favourites.enumerated() {
                if user.uid == uid {
                    self.favourites.remove(at: index)
                    self.profileList.reloadData()
                    return
                }
            }
        })
    }
    
    private func observeUsers() {
        usersRef = System.client.getUsersRef()
        
        usersAddedHandle = usersRef?.observe(.childAdded, with: { (snapshot) in
            guard let user = User(uid: snapshot.key, snapshot: snapshot) else {
                return
            }
            
            self.users.append(user)
            self.profileList.reloadData()
        })
        
        usersRemovedHandle = usersRef?.observe(.childRemoved, with: { (snapshot) in
            for (index, user) in self.favourites.enumerated() {
                if user.uid == snapshot.key {
                    self.users.remove(at: index)
                    self.profileList.reloadData()
                    return
                }
            }
        })
    }
}

// MARK: UITableViewDataSource
extension ProfileListViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filteredUsers.count
        } else {
            return favourites.count
        }
    }
    
    public func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user: User
        if searchActive && filteredUsers.count > indexPath.item {
            user = filteredUsers[indexPath.item]
        } else {
            user = favourites[indexPath.item]
        }
        
        guard let uid = user.uid, let cell = tableView.dequeueReusableCell(
            withIdentifier: Config.profileCell, for: indexPath) as? ProfileCell else {
                return ProfileCell()
        }
        
        cell.setUp(name: user.profile.name, job: user.profile.job, company: user.profile.company)
        
        Utility.getTeamLbl(user: user, completion: { (teamLblText) in
            cell.setTeamLabel(teamLblText)
        })
        
        Utility.getProfileImg(uid: uid, completion: { (image) in
            guard let image = image else {
                return
            }
            cell.setIconImage(image)
        })
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension ProfileListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user: User
        
        if searchActive && filteredUsers.count > indexPath.item {
            user = filteredUsers[indexPath.item]
        } else {
            user = favourites[indexPath.item]
        }
        
        self.performSegue(withIdentifier: Config.profileListToProfile, sender: user)
    }
}

// MARK: UITextFieldDelegate
extension ProfileListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        let favourite = favourites[indexPath.row]
            
        guard let favouriteUID = favourite.uid else {
            return
        }
            
        System.client.removeFavourte(uid: favouriteUID)
    }
}

// MARK: UISearchResultsUpdating
extension ProfileListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredUsers = users.filter { user in
            return user.profile.name.lowercased().contains(searchText.lowercased()) ||
                user.profile.username.lowercased().contains(searchText.lowercased())
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
