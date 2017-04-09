//
//  TeamRegistrationTableViewController.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/18/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class TeamRegistrationTableViewController: UITableViewController {
    
    private let teams = Teams.sharedInstance()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(TeamRegistrationTableViewController.update), name: Notification.Name(rawValue: "teams"), object: nil)
    }
    
    func update() {
        tableView.reloadData()
    }
    
  override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return teams.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamItemCell", for: indexPath) as! TeamItemTableViewCell
        let team = teams.retrieveTeamAt(index: indexPath.row)
        cell.teamName.text = team.name
        cell.teamIsLookingFor.text = team.lookingFor
        for i in 0..<team.members.count {
            switch i {
            case 0: cell.mmbrImage1.image = team.members[0].profile.image ?? UIImage(named: "Placeholder")!
            case 1: cell.mmbrImage2.image = team.members[1].profile.image ?? UIImage(named: "Placeholder")
            case 2: cell.mmbrImage3.image = team.members[2].profile.image ?? UIImage(named: "Placeholder")
            case 3: cell.mmbrImage4.image = team.members[3].profile.image ?? UIImage(named: "Placeholder")
            default: break
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationvc = segue.destination as? UINavigationController, let targetvc = destinationvc.topViewController as? TeamInfoTableViewController else {
             return
        }
        if let index = tableView.indexPathForSelectedRow?.row {
            targetvc.team = teams.retrieveTeamAt(index: index)
            targetvc.teamIndex = index
        }
    }
    

}
