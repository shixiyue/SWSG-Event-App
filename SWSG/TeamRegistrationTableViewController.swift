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
        
        addSlideMenuButton()
        NotificationCenter.default.addObserver(self, selector: #selector(TeamRegistrationTableViewController.update), name: Notification.Name(rawValue: "teams"), object: nil)
       // observeEvents()
    }
    
    func update() {
        tableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let targetvc = segue.destination as? TeamInfoTableViewController else {
            return
        }
        if let index = tableView.indexPathForSelectedRow?.row {
            targetvc.team = teams.retrieveTeamAt(index: index)
            targetvc.teamIndex = index
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
        let team = teams.retrieveTeamAt(index: indexPath.row)
        cell.teamName.text = team.name
        cell.teamIsLookingFor.text = team.lookingFor
        for i in 0..<team.members.count {
            switch i {
            case 0:
                if let user = System.client.getUserWith(uid: team.members[0]) {
                cell.mmbrImage1.image = user.profile.image ?? UIImage(named: "Placeholder")!
                }
            case 1:
                if let user = System.client.getUserWith(uid: team.members[1]) {
                cell.mmbrImage2.image = user.profile.image ?? UIImage(named: "Placeholder")
                }
            case 2:
                 if let user = System.client.getUserWith(uid: team.members[2]) {
                cell.mmbrImage3.image = user.profile.image ?? UIImage(named: "Placeholder")
                }
            case 3:
                 if let user = System.client.getUserWith(uid: team.members[3]) {
                cell.mmbrImage4.image = user.profile.image ?? UIImage(named: "Placeholder")
                }
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
