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
    fileprivate let teams = Teams.sharedInstance()
    
    private var teamRef: FIRDatabaseReference!
    private var teamAddedHandle: FIRDatabaseHandle?
    private var teamChangedHandle: FIRDatabaseHandle?
    private var teamDeletedHandle: FIRDatabaseHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        addSlideMenuButton()
       // NotificationCenter.default.addObserver(self, selector: #selector(TeamRegistrationTableViewController.update), name: Notification.Name(rawValue: "teams"), object: nil)
        observeEvents()
    }
    
    func update() {
        print("updating")
        print("\(teams.count)")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let targetvc = segue.destination as? TeamInfoTableViewController else {
            return
        }
        if let index = tableView.indexPathForSelectedRow?.row {
            targetvc.team = teams.retrieveTeamWith(index: index)
        }
    }
    
    private func observeEvents() {
        // Use the observe method to listen for new
        // channels being written to the Firebase DB
        teamRef = System.client.getTeamsRef()
        teamAddedHandle = teamRef.observe(.childAdded, with: { (snapshot) -> Void in
            if let teams = System.client.getTeams(snapshot: snapshot) {
                print("team added")
                self.teams.replaceTeams(teams: teams)
                self.update()
            }
        })
        
        teamChangedHandle = teamRef.observe(.childChanged, with: { (snapshot) -> Void in
            if let teams = System.client.getTeams(snapshot: snapshot) {
                print("team changed")
                self.teams.replaceTeams(teams: teams)
                self.update()
            }
        })
        
        teamDeletedHandle = teamRef.observe(.childChanged, with: { (snapshot) -> Void in
            if let teams = System.client.getTeams(snapshot: snapshot) {
                print("team deleted")
                self.teams.replaceTeams(teams: teams)
                self.update()
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
        return teams.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamItemCell", for: indexPath) as! TeamItemTableViewCell
        guard let team = teams.retrieveTeamWith(index: indexPath.row) else {
            return cell
        }
        print("loading table view")
        cell.teamName.text = team.name
        cell.teamIsLookingFor.text = team.lookingFor
        for i in 0..<team.members.count {
            switch i {
            case 0:
                print("1st user")
                Utility.getProfileImg(uid: team.members[0], completion: {(image) in
                    cell.mmbrImage1.image = image
                })
            case 1:
                print("2nd user")
                Utility.getProfileImg(uid: team.members[1], completion: {(image) in
                    cell.mmbrImage1.image = image
                })
            case 2:
                print("3rd user")
                Utility.getProfileImg(uid: team.members[2], completion: {(image) in
                    cell.mmbrImage1.image = image
                })
            case 3:
                print("4th user")
                Utility.getProfileImg(uid: team.members[3], completion: {(image) in
                    cell.mmbrImage1.image = image
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
