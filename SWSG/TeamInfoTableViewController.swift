//
//  TeamInfoTableViewController.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/18/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

/**
 TeamInfoTableViewController inherits from UITableViewController, which is responsible for displaying the team information
 
 -Note: 
     - Tap on chat button on navigation bar to chat in team
     - Tap on `Edit` button on navigation bar to edit the team if you belong to that team
     - Tap on any team member cell to view member profile
 -SeeAlso: `Team`,`TagCell`,`TeamItemTableViewCell`,`SectionHeaderTableViewCell`
 */

import UIKit
import Firebase

class TeamInfoTableViewController: UITableViewController {
    //IB outlets
    @IBOutlet weak var buttonLbl: UIButton!
    @IBOutlet weak var chatBtn: UIBarButtonItem!
    @IBOutlet weak var joinView: UIView!
    @IBOutlet weak var editBtn: UIBarButtonItem!
    
    var team : Team?
    fileprivate var teamId : String?
    fileprivate var sizingCell: TagCell?
    
    private let teams = Teams()
    
    //handling error message
    private let joinTeamErrorMsg = "You can not join more than one team"
    private let quitTeamErrorMsg = "You do not belong to this team"
    private let fullTeamErrorMsg = "Team is full"
    private let editTeamErrorMsg = "You cannot edit this team!"
    private let chatErrorMsg = "You cannot chat with this team!"
    
    //firebase handling variables
    private var teamRef: FIRDatabaseReference!
    private var teamChangedHandle: FIRDatabaseHandle?
    
    fileprivate var containerHeight = CGFloat(100) {
        didSet {
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
            chatBtn.isEnabled = true
            editBtn.isEnabled = true
        } else if team.members.count < Config.maxTeamMember {
            buttonLbl.setTitle(Config.joinTeam, for: .normal)
            chatBtn.isEnabled = false
            editBtn.isEnabled = false
        } else {
            buttonLbl.setTitle(Config.fullTeam, for: .normal)
            chatBtn.isEnabled = false
            editBtn.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Name(rawValue: "reload"), object: nil)
        
        if let team = team {
            self.title = team.name
        }
        guard let user = System.activeUser, let rBBItems = self.navigationItem.rightBarButtonItems,
            let team = team else {
                return
        }
        for (index, item) in rBBItems.enumerated() {
            if item.tag == 1 && !team.containsMember(member: user) {
                self.navigationItem.rightBarButtonItems?.remove(at: index)
            }
        }
        setUpLayout()
        observeEvents()
    }
    
    fileprivate func setUpLayout() {
        if System.activeUser?.type.isParticipant == false {
            joinView.isHidden = true
        }
        
        guard let team = team, let user = System.activeUser else {
            return
        }
        
        if !team.containsMember(member: user) {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == Config.teamToChat, let channel = sender as? Channel {
            guard let chatVc = segue.destination as? ChannelViewController else {
                return
            }
            chatVc.senderDisplayName = System.activeUser?.profile.username
            chatVc.channel = channel
        } else if segue.identifier == Config.teamToProfile, let user = sender as? User,
            let profileVC = segue.destination as? ProfileViewController {
            profileVC.user = user
        } else if segue.identifier == "teamEdit", let destVC = segue.destination  as? TeamEditViewController {
            destVC.team = team
        }
    }
    
    @objc private func reload() {
        tableView.beginUpdates()
        tableView.layoutIfNeeded()
        tableView.endUpdates()
    }
    
    @IBAction func chatBtnPressed(_ sender: Any) {
        guard let team = team else {
            return
        }
        guard let user = System.activeUser, user.team == team.id else {
            self.present(Utility.getFailAlertController(message: chatErrorMsg), animated: true, completion: nil)
            return
        }
        System.client.getTeamChannel(for: team, completion: { (channel, error) in
            self.performSegue(withIdentifier: Config.teamToChat, sender: channel)
        })
    }
    @IBAction func EditBtnPressed(_ sender: Any) {
        guard let team = team else {
            return
        }
        guard let user = System.activeUser, user.team == team.id else {
            self.present(Utility.getFailAlertController(message: editTeamErrorMsg), animated: true, completion: nil)
            return
        }
        self.performSegue(withIdentifier: "teamEdit", sender: team)
    }
    
    ///handles the creation or deletion of a team from the database, on `Request to Join` or `Quit team` button tapped
    ///Update team members list and user team id
    @IBAction func onRqtToJoinButtonTapped(_ sender: Any) {
        let btnTitle = (sender as! UIButton).currentTitle ?? ""
        guard let user = System.activeUser, user.type.isParticipant else {
            self.present(Utility.getFailAlertController(message: joinTeamErrorMsg), animated: true, completion: nil)
            return
        }
        guard let team = team else {
            return
        }
        if btnTitle == Config.fullTeam {
            self.present(Utility.getFailAlertController(message: fullTeamErrorMsg), animated: true, completion: nil)
            return
        }
        if btnTitle == Config.joinTeam && user.team != Config.noTeam {
            self.present(Utility.getFailAlertController(message: joinTeamErrorMsg), animated: true, completion: nil)
            return
        }
        if btnTitle == Config.quitTeam && user.team != team.id {
            self.present(Utility.getFailAlertController(message: quitTeamErrorMsg), animated: true, completion: nil)
            return
        }
        if btnTitle == Config.joinTeam {
            user.setTeamId(id: team.id!)
            team.addMember(member: user)
        } else if btnTitle == Config.quitTeam {
            user.setTeamId(id: Config.noTeam)
            team.removeMember(member: user)
        }
        buttonLbl.setTitle(toggleBtnTitle(prevTitle: btnTitle, team: team), for: .normal)
        
        System.client.updateTeam(for: team)
        System.client.updateUser(newUser: user)
        
        if team.members.count == 0 {
            System.client.deleteTeam(for: team)
            Utility.popViewController(no: 1, viewController: self)
        }
        tableView.reloadData()
    }
    
    private func toggleBtnTitle(prevTitle: String, team: Team) -> String {
        if prevTitle == Config.joinTeam {
            return Config.quitTeam
        } else if prevTitle == Config.quitTeam {
            return Config.joinTeam
        } else {
            return ""
        }
    }
    
    ///firebase handling for any changes to the team object and display accordingly
    private func observeEvents() {
        guard let teamID = team?.id else {
            return
        }
        
        teamRef = System.client.getTeamRef(for: teamID)
        teamChangedHandle = teamRef.observe(.value, with: { (snapshot) -> Void in
            if let team = Team(id: snapshot.key, snapshot: snapshot) {
                self.team = team
                self.title = team.name
                self.tableView.reloadData()
            }
        })
    }
}

/// UITableViewDataSource methods
extension TeamInfoTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return team!.members.count+1
        } else {
            return 4
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
                guard team != nil else {
                    return cell
                }
                configureTeamMemberCell(cell: cell, at: indexPath.row - 1)
                return cell
            }
        }else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "sectionHeaderCell", for: indexPath) as! SectionHeaderTableViewCell
                cell.sectionHeaderLbl.text = "Our skills"
                return cell
                
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "tagdisplaycell", for: indexPath) as! TagTableViewCell
                configureTagCell(cell: cell)
                return cell
            }
            else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "sectionHeaderCell", for: indexPath) as! SectionHeaderTableViewCell
                cell.sectionHeaderLbl.text = "Looking For Members like..."
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "lookingForCell", for: indexPath) as! TeamLookingForTableViewCell
                cell.lookingForLbl.text = team?.lookingFor
                return cell
            }
        }
    }
    
    ///configure the team member cell
    private func configureTeamMemberCell(cell: TeamMemberTableViewCell, at index: Int) {
        guard let team = team else {
            return
        }
        System.client.getUserWith(uid: team.members[index], completion: {
            (user, error) in
            if let user = user {
                cell.nameLbl.text = user.profile.name
                cell.jobLbl.text = user.profile.job
                cell.companyLbl.text = user.profile.company
                cell.descLbl.text = user.profile.desc
            }
        })
        cell.profileimage = Utility.roundUIImageView(for: cell.profileimage)
        cell.profileimage.image = Config.placeholderImg
        Utility.getProfileImg(uid: team.members[index], completion: {(image) in
            if let image = image {
                cell.profileimage.image = image
            }
        })
    }
    
    ///configure the tag cell, load tags collectionview
    private func configureTagCell(cell: TagTableViewCell) {
        cell.tagCollectionView.delegate = self
        let cellNib = UINib(nibName: "TagCell", bundle: nil)
        cell.tagCollectionView.register(cellNib, forCellWithReuseIdentifier: "TagCell")
        cell.tagCollectionView.backgroundColor = UIColor.clear
        self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! TagCell?
        cell.tagCollectionView.reloadData()
        if cell.tagCollectionView.contentSize.height > self.containerHeight {
            self.containerHeight = cell.tagCollectionView.contentSize.height
        }
    }
}
/// UITableViewDelegate methods
extension TeamInfoTableViewController {
    
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        guard let team = team, indexPath.section == 0 else {
            return
        }
        guard indexPath.section == 0 else {
            return
        }
        System.client.getUserWith(uid: team.members[indexPath.row-1], completion: {
            (user, error) in
            if let user = user {
                self.performSegue(withIdentifier: Config.teamToProfile, sender: user)
            }
        })
    }
}


extension TeamInfoTableViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let team = self.team, let tags = team.tags {
            return tags.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
        self.configureCell(cell: cell, forIndexPath: indexPath)
        cell.delete.isHidden = true
        return cell
    }
    
    fileprivate  func configureCell(cell: TagCell, forIndexPath indexPath: IndexPath) {
        if let team = self.team, let tags = team.tags {
            let tag = tags[indexPath.row]
            cell.tagName.text = tag
        }
    }
}

extension TeamInfoTableViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        self.configureCell(cell: self.sizingCell!, forIndexPath: indexPath)
        let size = self.sizingCell!.tagName.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        return CGSize(width: size.width, height: size.height*2)
    }
}
