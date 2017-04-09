//
//  IdeasListTableViewController.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/23/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import Firebase

class IdeasListTableViewController: BaseViewController {
    
    override var menuYOffset: CGFloat {
        return super.menuYOffset + ideaListTableView.contentOffset.y
    }
    
    fileprivate let ideas = Ideas.sharedInstance()
    
    @IBOutlet private var ideaListTableView: UITableView!
    
    private var ideasRef: FIRDatabaseReference?
    private var ideasRefHandle: FIRDatabaseHandle?
    
    private enum ideaCreateErrorMsg: String {
        case notParticipant = "Sorry, only participants of SWSG can create an idea!"
        case noTeam = "Sorry, only participants who have joined teams can create an idea!"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showDetails", let detailsViewController = segue.destination as? IdeaDetailsTableViewController, let index = sender as? Int else {
            return
        }
        detailsViewController.idea = ideas.retrieveIdeaAt(index: index)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ideaListTableView.dataSource = self
        ideaListTableView.delegate = self
        addSlideMenuButton()
        ideasRef = System.client.getIdeasRef()
        observeIdeas()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: Notification.Name(rawValue: "refresh"), object: nil)
    }
    
    private func observeIdeas() {
        guard let ideasRef = ideasRef else {
            return
        }
        
        ideasRefHandle = ideasRef.observe(.value, with: { (snapshot) -> Void in
            self.ideas.update(snapshot: snapshot)
            DispatchQueue.main.async {
                self.ideaListTableView.reloadData()
            }
        })
    }
    
    @objc private func refresh(_ notification: NSNotification) {
        DispatchQueue.main.async {
            self.ideaListTableView.reloadData()
        }
    }
    
    @IBAction func addIdea() {
        guard let user = System.activeUser, user.type.isParticipant else {
            present(Utility.getFailAlertController(message: ideaCreateErrorMsg.notParticipant.rawValue), animated: true, completion: nil)
            return
        }
        guard user.hasTeam else {
            present(Utility.getFailAlertController(message: ideaCreateErrorMsg.noTeam.rawValue), animated: true, completion: nil)
            return
        }
        performSegue(withIdentifier: "addIdea", sender: nil)
    }
    
    deinit {
        if let refHandle = ideasRefHandle {
            ideasRef?.removeObserver(withHandle: refHandle)
        }
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension IdeasListTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ideas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ideaItemCell", for: indexPath) as! IdeaItemTableViewCell
        
        let idea = ideas.retrieveIdeaAt(index: indexPath.row)
        cell.setIdea(idea)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: indexPath.row)
    }

}
