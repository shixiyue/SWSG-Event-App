//
//  TeamRegistrationTableViewController.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/18/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import Firebase

class TeamRegistrationTableViewController: BaseViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    fileprivate var teams = Teams()
    fileprivate var filteredTeams = Teams()
    fileprivate var searchActive = false
    
    private var teamRef: FIRDatabaseReference!
    private var teamAddedHandle: FIRDatabaseHandle?
    private var teamChangedHandle: FIRDatabaseHandle?
    private var teamDeletedHandle: FIRDatabaseHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        addSlideMenuButton()
        tableView.separatorStyle = .none
        setUpLayout()
        setUpSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        teams = Teams()
        observeEvents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func update() {
        print("updating")
        print("\(teams.count)")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func setUpLayout() {
        if System.activeUser?.type.isParticipant == false {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    fileprivate func setUpSearchBar() {
        Utility.setUpSearchBar(searchBar, viewController: self, selector: #selector(donePressed))
        Utility.styleSearchBar(searchBar)
    }
    
    func donePressed() {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let targetvc = segue.destination as? TeamInfoTableViewController else {
            return
        }
        
        if let index = tableView.indexPathForSelectedRow?.row {
            var team: Team?
            
            if searchActive {
                team = filteredTeams.retrieveTeamWith(index: index)
            } else {
                team = teams.retrieveTeamWith(index: index)
            }
            
            targetvc.team = team
        }
    }
    
    private func observeEvents() {
        // Use the observe method to listen for new
        // channels being written to the Firebase DB
        teamRef = System.client.getTeamsRef()
        teamAddedHandle = teamRef.observe(.childAdded, with: { (snapshot) -> Void in
            if let team = System.client.getTeam(snapshot: snapshot) {
                print("team added")
                self.teams.addTeam(team: team)
                self.tableView.reloadData()
            }
        })
        
        teamChangedHandle = teamRef.observe(.childChanged, with: { (snapshot) -> Void in
            if let team = System.client.getTeam(snapshot: snapshot) {
                print("team changed")
                self.teams.replaceTeam(for: team)
                self.tableView.reloadData()
            }
        })
        
        teamDeletedHandle = teamRef.observe(.childRemoved, with: { (snapshot) -> Void in
            if let team = System.client.getTeam(snapshot: snapshot) {
                print("team deleted")
                self.teams.removeTeam(team: team)
                self.tableView.reloadData()
            }
        })
        
    }

}

extension TeamRegistrationTableViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchActive {
            return filteredTeams.count
        } else {
            return teams.count
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamItemCell", for: indexPath) as! TeamItemTableViewCell
        
        var teamTemp: Team?
        
        if searchActive {
            teamTemp = filteredTeams.retrieveTeamWith(index: indexPath.row)
        } else {
            teamTemp = teams.retrieveTeamWith(index: indexPath.row)
        }
        
        guard let team = teamTemp else {
            return cell
        }
        
        print("loading table view")
        cell.teamName.text = team.name
        cell.teamIsLookingFor.text = team.lookingFor
        for i in 0..<4 {
            switch i {
            case 0:
                print("1st user")
                cell.mmbrImage1 = Utility.roundUIImageView(for: cell.mmbrImage1)
                cell.mmbrImage1.image = Config.placeholderImg
                Utility.getProfileImg(uid: team.members[0], completion: {(image) in
                    cell.mmbrImage1.image = image
                })
            case 1:
                print("2nd user")
                if team.members.count < 2 {
                    cell.mmbrImage2.image = nil
                    break
                }
                cell.mmbrImage2 = Utility.roundUIImageView(for: cell.mmbrImage2)
                cell.mmbrImage2.image = Config.placeholderImg
                Utility.getProfileImg(uid: team.members[1], completion: {(image) in
                    cell.mmbrImage2.image = image
                })
            case 2:
                print("3rd user")
                if team.members.count < 3 {
                    cell.mmbrImage3.image = nil
                    break
                }
                cell.mmbrImage3 = Utility.roundUIImageView(for: cell.mmbrImage3)
                cell.mmbrImage3.image = Config.placeholderImg
                Utility.getProfileImg(uid: team.members[2], completion: {(image) in
                    cell.mmbrImage3.image = image
                })
            case 3:
                print("4th user")
                if team.members.count < 4 {
                    cell.mmbrImage4.image = nil
                    break
                }
                
                cell.mmbrImage4 = Utility.roundUIImageView(for: cell.mmbrImage4)
                cell.mmbrImage4.image = Config.placeholderImg
                Utility.getProfileImg(uid: team.members[3], completion: {(image) in
                    cell.mmbrImage4.image = image
                })
            default: break
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}

// MARK: UISearchBarDelegate
extension TeamRegistrationTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredTeams.teams = teams.teams.filter { team in
            return team.name.lowercased().contains(searchText.lowercased())
        }
        
        if searchText.characters.count == 0 {
            searchActive = false
        } else {
            searchActive = true
        }
        
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
}
