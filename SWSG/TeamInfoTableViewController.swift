//
//  TeamInfoTableViewController.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/18/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class TeamInfoTableViewController: UITableViewController {
    
    @IBOutlet weak var buttonLbl: UIButton!
    var team : Team?
    var teamIndex : Int?
    private let teams = Teams.sharedInstance()
    private let joinTeamErrorMsg = "You can not join more than one team"
    private let quitTeamErrorMsg = "You do not belong to this team"
    private let fullTeamErrorMsg = "Team is full"
    
    @IBAction func onBackButtonClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        if let participant = System.activeUser as? Participant, let team = team {
            if team.containsMember(member: participant) {
                buttonLbl.setTitle(Config.quitTeam, for: .normal)
            } else if team.members.count < Config.maxTeamMember {
                print("\(team.members.count)")
                buttonLbl.setTitle(Config.joinTeam, for: .normal)
            } else {
                buttonLbl.setTitle(Config.fullTeam, for: .normal)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    @IBAction func onRqtToJoinButtonTapped(_ sender: Any) {
        guard let participant = System.activeUser as? Participant else {
            self.present(Utility.getFailAlertController(message: joinTeamErrorMsg), animated: true, completion: nil)
            return
        }
        if (sender as! UIButton).currentTitle == Config.fullTeam {
            self.present(Utility.getFailAlertController(message: fullTeamErrorMsg), animated: true, completion: nil)
            return
        }
        if (sender as! UIButton).currentTitle == Config.joinTeam {
            if participant.team != nil {
                self.present(Utility.getFailAlertController(message: joinTeamErrorMsg), animated: true, completion: nil)
                return
            }
            participant.setTeamIndex(index: teamIndex!)
            System.activeUser = participant
            team?.addMember(member: participant)
            print("member added")
            teams.replaceTeamAt(index: teamIndex!, with: team!)
            buttonLbl.setTitle(Config.quitTeam, for: .normal)
        } else if (sender as! UIButton).currentTitle == Config.quitTeam {
            if participant.team != teamIndex {
                self.present(Utility.getFailAlertController(message: quitTeamErrorMsg), animated: true, completion: nil)
                return
            }
            participant.setTeamIndex(index: nil)
            System.activeUser = participant
            team?.removeMember(member: participant)
            print("member deleted")
            if team!.members.count < Config.maxTeamMember {
                buttonLbl.setTitle(Config.joinTeam, for: .normal)
            } else {
                buttonLbl.setTitle(Config.fullTeam, for: .normal)
            }
            
        }
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return team!.members.count+1
        } else {
            return 2
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "sectionHeaderCell", for: indexPath) as! SectionHeaderTableViewCell
                cell.sectionHeaderLbl.text = "Our Members"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "teamMemberCell", for: indexPath) as! TeamMemberTableViewCell
                cell.nameLbl.text = team?.members[indexPath.row - 1].profile.name
                return cell
            }
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "sectionHeaderCell", for: indexPath) as! SectionHeaderTableViewCell
                cell.sectionHeaderLbl.text = "Looking For:"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "lookingForCell", for: indexPath) as! TeamLookingForTableViewCell
                cell.lookingForLbl.text = team?.lookingFor
                return cell
            }
        }
        
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
