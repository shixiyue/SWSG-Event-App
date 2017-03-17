//
//  ProfileViewController.swift
//  SWSG
//
//  Created by shixiyue on 17/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var profileImgButton: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var teamLbl: UILabel!
    @IBOutlet var profileList: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileList.tableFooterView = UIView(frame: CGRect.zero)
        profileList.allowsSelection = false
        
        guard let user = System.activeUser else {
            Utility.logOutUser(currentViewController: self)
            return
        }
        profileImgButton.setImage(user.profile.image, for: .normal)
        nameLbl.text = user.profile.name
        
        if let team = user.team {
            teamLbl.text = team.name
        } else {
            teamLbl.text = "No Team yet"
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editProfile(_ sender: UIButton) {
        print(true)
    }

    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.item
        let (field, content) = ProfileItems.items[index]
        
        guard let cell = profileList.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as? ProfileTableViewCell else {
            return ProfileTableViewCell()
        }
        
        cell.field.text = field
        cell.content.text = content
        return cell
    }

}
