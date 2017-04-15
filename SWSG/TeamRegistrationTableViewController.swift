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
    fileprivate var teams = Teams()
    private var teamRef: FIRDatabaseReference!
    private var teamAddedHandle: FIRDatabaseHandle?
    private var teamChangedHandle: FIRDatabaseHandle?
    private var teamDeletedHandle: FIRDatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        addSlideMenuButton()
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        teams = Teams()
        observeEvents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func update() {
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
        
        teamRef = System.client.getTeamsRef()
        teamAddedHandle = teamRef.observe(.childAdded, with: { (snapshot) -> Void in
            if let team = System.client.getTeam(snapshot: snapshot) {
                self.teams.addTeam(team: team)
                self.tableView.reloadData()
            }
        })
        
        teamChangedHandle = teamRef.observe(.childChanged, with: { (snapshot) -> Void in
            if let team = System.client.getTeam(snapshot: snapshot) {
                self.teams.replaceTeam(for: team)
                print("team cheanged in registration")
                self.tableView.reloadData()
            }
        })
        
        teamDeletedHandle = teamRef.observe(.childRemoved, with: { (snapshot) -> Void in
            if let team = System.client.getTeam(snapshot: snapshot) {
                self.teams.removeTeam(team: team)
                self.tableView.reloadData()
            }
        })
        
    }
    
    func fillProfileImg(at cell: TeamItemTableViewCell, with index: Int, team: Team) {
  
        switch(index) {
        case 0:
            cell.mmbrImage1 = Utility.roundUIImageView(for: cell.mmbrImage1)
            Utility.getProfileImg(uid: team.members[0], completion: {(image) in
                cell.mmbrImage1.image = image
            })
        case 1:
            cell.mmbrImage2 = Utility.roundUIImageView(for: cell.mmbrImage2)
            
            Utility.getProfileImg(uid: team.members[1], completion: {(image) in
                cell.mmbrImage2.image = image
            })
            
        case 2:
            cell.mmbrImage3 = Utility.roundUIImageView(for: cell.mmbrImage3)
            Utility.getProfileImg(uid: team.members[2], completion: {(image) in
                cell.mmbrImage3.image = image
            })
        case 3:
            cell.mmbrImage4 = Utility.roundUIImageView(for: cell.mmbrImage4)
            Utility.getProfileImg(uid: team.members[3], completion: {(image) in
                cell.mmbrImage4.image = image
            })
        default:
            break
        }
    }
    
}

extension TeamRegistrationTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamItemCell", for: indexPath) as! TeamItemTableViewCell
        guard let team = teams.retrieveTeamWith(index: indexPath.row) else {
            return cell
        }
        cell.teamName.text = team.name
        cell.teamIsLookingFor.text = team.lookingFor
        for i in 0..<team.members.count {
            fillProfileImg(at: cell, with: i, team: team)
        }
        return cell
    }
}

extension TeamRegistrationTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
