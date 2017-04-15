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
    fileprivate var filteredIdeas = [Idea]()
    fileprivate var searchActive = false {
        willSet(newSearchActive) {
            ideaListTableView.reloadData()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet private var ideaListTableView: UITableView!
    
    private var ideasRef: FIRDatabaseReference?
    private var ideasAddRefHandle: FIRDatabaseHandle?
    private var ideasChangeRefHandle: FIRDatabaseHandle?
    private var ideasDeleteRefHandle: FIRDatabaseHandle?
    
    private enum ideaCreateErrorMsg: String {
        case notParticipant = "Sorry, only participants of SWSG can create an idea!"
        case noTeam = "Sorry, only participants who have joined teams can create an idea!"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showDetails", let detailsViewController = segue.destination as? IdeaDetailsTableViewController, let index = sender as? Int else {
            return
        }
        
        if searchActive && filteredIdeas.count > index {
            detailsViewController.idea = filteredIdeas[index]
        } else {
            detailsViewController.idea = ideas.retrieveIdeaAt(index: index)
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ideaListTableView.dataSource = self
        ideaListTableView.delegate = self
        addSlideMenuButton()
        setUpLayout()
        ideasRef = System.client.getIdeasRef()
        observeIdeas()
    }
    
    private func setUpLayout() {
        if System.activeUser?.type.isParticipant == false {
            self.navigationItem.rightBarButtonItem = nil
        }
        
        Utility.setUpSearchBar(searchBar, viewController: self, selector: #selector(donePressed))
        Utility.styleSearchBar(searchBar)
    }
    
    func donePressed() {
        self.view.endEditing(true)
        
        if searchBar.text?.characters.count == 0 {
            searchActive = false
        }
    }
    
    private func observeIdeas() {
        guard let ideasRef = ideasRef else {
            return
        }
        
        ideasAddRefHandle = ideasRef.observe(.childAdded, with: { (snapshot) -> Void in
            self.ideas.add(snapshot: snapshot)
            DispatchQueue.main.async {
                self.ideaListTableView.reloadData()
                self.loadMainImages()
            }
        })
        
        ideasChangeRefHandle = ideasRef.observe(.childChanged, with: { (snapshot) -> Void in
            self.ideas.update(snapshot: snapshot)
            DispatchQueue.main.async {
                self.ideaListTableView.reloadData()
                self.loadMainImages()
            }
        })
        
        ideasDeleteRefHandle = ideasRef.observe(.childRemoved, with: { (snapshot) in
            guard let index = self.ideas.remove(snapshot: snapshot) else {
                return
            }
            let indexPath = [IndexPath(row: index, section: 0)]
            DispatchQueue.main.async {
                self.ideaListTableView.deleteRows(at: indexPath, with: .none)
            }
        })
    }
    
    private func loadMainImages() {
        for idea in ideas.getAllIdeas() {
            idea.loadMainImage(completion: { (needRefresh) in
                guard needRefresh else {
                    return
                }
                DispatchQueue.main.async {
                    self.ideaListTableView.reloadData()
                }
            })
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
        if let addHandle = ideasAddRefHandle {
            ideasRef?.removeObserver(withHandle: addHandle)
        }
        if let changeHandle = ideasChangeRefHandle {
            ideasRef?.removeObserver(withHandle: changeHandle)
        }
        if let deleteHandle = ideasDeleteRefHandle {
            ideasRef?.removeObserver(withHandle: deleteHandle)
        }
    }
    
}

extension IdeasListTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchActive {
            return filteredIdeas.count
        } else {
            return ideas.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ideaItemCell", for: indexPath) as! IdeaItemTableViewCell
        
        let idea: Idea
        
        if searchActive && filteredIdeas.count > indexPath.row {
            idea = filteredIdeas[indexPath.row]
        } else {
            idea = ideas.retrieveIdeaAt(index: indexPath.row)
        }
        
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

// MARK: UISearchResultsUpdating
extension IdeasListTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredIdeas = ideas.getAllIdeas().filter { idea in
            return idea.name.lowercased().contains(searchText.lowercased())
        }
        
        if searchText.characters.count == 0 {
            searchActive = false
        } else {
            searchActive = true
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
}
