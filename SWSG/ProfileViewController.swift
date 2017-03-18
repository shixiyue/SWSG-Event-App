//
//  ProfileViewController.swift
//  SWSG
//
//  Created by shixiyue on 17/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet private var profileImgButton: UIButton!
    @IBOutlet private var nameLbl: UILabel!
    @IBOutlet private var teamLbl: UILabel!
    @IBOutlet private var profileList: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        setUpProfileList()
        setUpUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        profileList.reloadData()
        setUpUserInfo()
    }
    
    private func setUpProfileList() {
        profileList.tableFooterView = UIView(frame: CGRect.zero)
        profileList.allowsSelection = false
    }
    
    private func setUpUserInfo() {
        guard let user = System.activeUser else {
            Utility.logOutUser(currentViewController: self)
            return
        }
        
        profileImgButton.setImage(user.profile.image, for: .normal)
        nameLbl.text = user.profile.name
        
        guard let participant = user as? Participant else {
            teamLbl.text = nil
            return
        }
        if let team = participant.team {
            teamLbl.text = team.name
        } else {
            teamLbl.text = Config.noTeamLabel
        }
    }

    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.item
        let (field, content) = ProfileItems.items[index]
        
        guard let cell = profileList.dequeueReusableCell(withIdentifier: Config.profileCell, for: indexPath) as? ProfileTableViewCell else {
            return ProfileTableViewCell()
        }
        
        cell.field.text = field
        cell.content.text = content
        return cell
    }

}
