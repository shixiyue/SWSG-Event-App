//
//  TeamCreateTableViewController.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/18/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class TeamCreateTableViewController: UITableViewController, UICollectionViewDataSource  {

    @IBOutlet weak var teamName: UITextField!
    @IBOutlet weak var skills: UITextField!
    @IBOutlet weak var lookingFor: UITextField!
    
    private let teamCreateErrorMsg = "Sorry, only participants of SWSG can create a team!"
    private let emptyFieldErrorMsg = "Fields cannot be empty!"
    private let mtplTeamErrorMsg = "You can not join more than 1 team!"
    
    private let teams = Teams.sharedInstance()
    var sizingCell: TagCell?
    
    let TAGS = ["Tech", "Design", "Humor", "Travel", "Music", "Writing", "Social Media", "Life", "Education", "Edtech", "Education Reform", "Photography", "Startup", "Poetry", "Women In Tech", "Female Founders", "Business", "Fiction", "Love", "Food", "Sports"]
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "TagCell", bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: "TagCell")
        self.collectionView.backgroundColor = UIColor.clear
        self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! TagCell?
    }
    @IBAction func onDoneButtonClick(_ sender: Any) {
        guard let user = System.activeUser, user.type.isParticipant else {
            self.present(Utility.getFailAlertController(message: teamCreateErrorMsg), animated: true, completion: nil)
            return
        }
        guard teamName.text! != "" , skills.text! != "", lookingFor.text! != "" else {
            self.present(Utility.getFailAlertController(message: emptyFieldErrorMsg),animated: true, completion: nil)
            return
        }
        guard System.activeUser?.team == Config.noTeam else {
            self.present(Utility.getFailAlertController(message: mtplTeamErrorMsg),animated: true, completion: nil)
            return
        }
        
        let team = Team(members: [user], name: teamName.text!, info: skills.text!, lookingFor: lookingFor.text!, isPrivate: false)
        teams.addTeam(team: team)
        user.setTeamIndex(index: teams.count-1)
        System.activeUser = user
        dismiss(animated: true, completion: nil)
        Utility.onBackButtonClick(tableViewController: self)
    }

    @IBAction func onBackBtnClick(_ sender: Any) {
        Utility.onBackButtonClick(tableViewController: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    public override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    


}


extension TeamCreateTableViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TAGS.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
        cell.tagName.text = TAGS[indexPath.row]
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let data = TAGS[indexPath.item]
        let sectionInset = (self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset
        let widthToSubtract = sectionInset!.left + sectionInset!.right
        
        let requiredWidth = collectionView.bounds.size.width
        
        
        let targetSize = CGSize(width: requiredWidth, height: 0)
        
        //sizingCell.configureCell(data, delegate: self)
        let adequateSize = self.sizingCell?.preferredLayoutSizeFittingSize(targetSize: targetSize)
        return CGSize(width: (self.collectionView?.bounds.width)! - widthToSubtract, height: adequateSize!.height)
    }

    
    
   }

