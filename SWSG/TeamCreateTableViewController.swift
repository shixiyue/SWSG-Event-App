//
//  TeamCreateTableViewController.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/18/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class TeamCreateTableViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {

    @IBOutlet weak var teamName: UITextField!
    @IBOutlet weak var lookingFor: GrayBorderTextView!
    
    @IBOutlet weak var tag: UITextField!
    private let teamCreateErrorMsg = "Sorry, only participants of SWSG can create a team!"
    private let emptyFieldErrorMsg = "Fields cannot be empty!"
    private let mtplTeamErrorMsg = "You can not join more than 1 team!"
    
    private let teams = Teams.sharedInstance()
    var sizingCell: TagCell?
    internal var tags = [String]() {
        didSet {
           NotificationCenter.default.post(name: Notification.Name(rawValue: "tags"), object: self)
        }
    }
    private var containerHeight = CGFloat(100)
    internal var lookingForCellHeight = CGFloat(100)

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func onSaveBtnClick(_ sender: Any) {
        guard let tagToAdd = tag.text, !tagToAdd.isEmpty else {
            present(Utility.getFailAlertController(message: "Tag field cannot be empty!"), animated: true, completion: nil)
            return
        }
        tags.append(tagToAdd)
        tag.text = ""
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        lookingFor.setPlaceholder("Skills looking for...")
        lookingFor.delegate = self
        tableView.separatorStyle = .none
        let cellNib = UINib(nibName: "TagCell", bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: "TagCell")
        self.collectionView.backgroundColor = UIColor.clear
        self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! TagCell?
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Name(rawValue: "tags"), object: nil)
    }
    
    @IBAction func onDoneButtonClick(_ sender: Any) {
        guard let user = System.activeUser, user.type.isParticipant else {
            self.present(Utility.getFailAlertController(message: teamCreateErrorMsg), animated: true, completion: nil)
            return
        }
        guard let name = teamName.text, !name.isEmpty, let looking = lookingFor.text, !looking.isEmpty else {
            self.present(Utility.getFailAlertController(message: emptyFieldErrorMsg),animated: true, completion: nil)
            return
        }
        guard System.activeUser?.team == Config.noTeam else {
            self.present(Utility.getFailAlertController(message: mtplTeamErrorMsg),animated: true, completion: nil)
            return
        }
        
        let team = Team(members: [user], name: name, lookingFor: looking, isPrivate: false, tags: tags)
        teams.addTeam(team: team)
        user.setTeamIndex(index: teams.count-1)
        System.activeUser = user
        dismiss(animated: true, completion: nil)
        Utility.onBackButtonClick(tableViewController: self)
    }

    @IBAction func onBackBtnClick(_ sender: Any) {
        Utility.onBackButtonClick(tableViewController: self)
    }
    
    @objc private func reload() {
        self.tableView.beginUpdates()
        if collectionView.contentSize.height > containerHeight {
            containerHeight = collectionView.contentSize.height
        }
        collectionView.reloadData()
        self.tableView.endUpdates()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.item == 0 {
            return 150
        }else if indexPath.item == 2 {
            return CGFloat(containerHeight)
        } else if indexPath.item == 3 {
            return lookingForCellHeight
        }else {
            return 60
        }
    }
    
}


extension TeamCreateTableViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
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
        let tag = tags[indexPath.row]
        cell.tagName.text = tag
    }
    
   }

extension TeamCreateTableViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.tableView.beginUpdates()
        if textView.contentSize.height > CGFloat(60) {
            self.lookingForCellHeight = textView.contentSize.height
        }
        self.tableView.endUpdates()
        
    }
}


