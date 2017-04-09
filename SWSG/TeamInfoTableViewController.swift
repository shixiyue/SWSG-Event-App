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
        var sizingCell: TagCell?
    private let teams = Teams.sharedInstance()
    private let joinTeamErrorMsg = "You can not join more than one team"
    private let quitTeamErrorMsg = "You do not belong to this team"
    private let fullTeamErrorMsg = "Team is full"
    private var containerHeight = CGFloat(100) {
        didSet {
        print("setting container view height")
         NotificationCenter.default.post(name: Notification.Name(rawValue: "reload"), object: self)
        }
    }

    @IBAction func onBackButtonClick(_ sender: Any) {
        Utility.onBackButtonClick(tableViewController: self)
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let user = System.activeUser, user.type.isParticipant, let team = team else {
            return
        }
        if team.containsMember(member: user) {
            buttonLbl.setTitle(Config.quitTeam, for: .normal)
        } else if team.members.count < Config.maxTeamMember {
            print("\(team.members.count)")
            buttonLbl.setTitle(Config.joinTeam, for: .normal)
        } else {
            buttonLbl.setTitle(Config.fullTeam, for: .normal)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Name(rawValue: "reload"), object: nil)
    }
    
    @objc private func reload() {
        tableView.beginUpdates()
        print("reloading height")
        tableView.layoutIfNeeded()
        tableView.endUpdates()
    }
    

    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    @IBAction func onRqtToJoinButtonTapped(_ sender: Any) {
        print("tapped")
        guard let user = System.activeUser, user.type.isParticipant else {
            self.present(Utility.getFailAlertController(message: joinTeamErrorMsg), animated: true, completion: nil)
            return
        }
        if (sender as! UIButton).currentTitle == Config.fullTeam {
            self.present(Utility.getFailAlertController(message: fullTeamErrorMsg), animated: true, completion: nil)
            return
        }
        if (sender as! UIButton).currentTitle == Config.joinTeam {
            if user.team != -1 {
                self.present(Utility.getFailAlertController(message: joinTeamErrorMsg), animated: true, completion: nil)
                return
            }
            print("in TeamInfoTableViewController, set team index to \(teamIndex!), current team is \(user.team)")
            user.setTeamIndex(index: teamIndex!)
            System.activeUser = user
            
            team?.addMember(member: user)
            print("member added")
            teams.replaceTeamAt(index: teamIndex!, with: team!)
            buttonLbl.setTitle(Config.quitTeam, for: .normal)
        } else if (sender as! UIButton).currentTitle == Config.quitTeam {
            if user.team != teamIndex {
                self.present(Utility.getFailAlertController(message: quitTeamErrorMsg), animated: true, completion: nil)
                return
            }
            user.setTeamIndex(index: -1)
            System.activeUser = user
            team?.removeMember(member: user)
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
            return 4
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 44
            } else {
                return UITableViewAutomaticDimension
            }
        } else {
            if indexPath.row == 0 {
                return 44
            } else if indexPath.row == 1 {
                return containerHeight
            } else if indexPath.row == 2 {
                return 44
            } else {
                return UITableViewAutomaticDimension
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
                cell.jobLbl.text = team?.members[indexPath.row-1].profile.job
                cell.companyLbl.text = team?.members[indexPath.row - 1].profile.company
                cell.descLbl.text = team?.members[indexPath.row-1].profile.desc
                cell.profileimage.image = team?.members[indexPath.row - 1].profile.image ?? UIImage(named: "Placeholder")
                return cell
            }
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "sectionHeaderCell", for: indexPath) as! SectionHeaderTableViewCell
                cell.sectionHeaderLbl.text = "Our skills"
                return cell

            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "tagdisplaycell", for: indexPath) as! TagTableViewCell
                cell.tagCollectionView.delegate = self
                let cellNib = UINib(nibName: "TagCell", bundle: nil)
                cell.tagCollectionView.register(cellNib, forCellWithReuseIdentifier: "TagCell")
                cell.tagCollectionView.backgroundColor = UIColor.clear
                self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! TagCell?
                cell.tagCollectionView.performBatchUpdates({() -> Void in
                cell.tagCollectionView.reloadData()
                }, completion: {(_) -> Void in
                    if cell.tagCollectionView.contentSize.height > self.containerHeight {
                        self.containerHeight = cell.tagCollectionView.contentSize.height
                    }
                    print("containerheight is \(self.containerHeight) while collection height is \(cell.tagCollectionView.contentSize.height)")
                })
                return cell
            }
            else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "sectionHeaderCell", for: indexPath) as! SectionHeaderTableViewCell
                cell.sectionHeaderLbl.text = "Looking For Members like..."
                return cell
            } else {
                print("loading looking for")
                let cell = tableView.dequeueReusableCell(withIdentifier: "lookingForCell", for: indexPath) as! TeamLookingForTableViewCell
                cell.lookingForLbl.text = team?.lookingFor
                return cell
            }
        }
        
    }
    
}

extension TeamInfoTableViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let team = self.team, let tags = team.tags {
        return tags.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
        self.configureCell(cell: cell, forIndexPath: indexPath)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        self.configureCell(cell: self.sizingCell!, forIndexPath: indexPath)
        let size = self.sizingCell!.tagName.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        return CGSize(width: size.width*1.5, height: size.height*2)
    }
    
    func configureCell(cell: TagCell, forIndexPath indexPath: IndexPath) {
        if let team = self.team, let tags = team.tags {
            let tag = tags[indexPath.row]
            cell.tagName.text = tag
        }
    }

    
}
