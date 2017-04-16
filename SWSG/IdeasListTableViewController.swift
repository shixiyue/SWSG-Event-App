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
    
    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private var ideaListTableView: UITableView!
    
    private var ideasRef: FIRDatabaseReference?
    private var ideasAddRefHandle: FIRDatabaseHandle?
    private var ideasChangeRefHandle: FIRDatabaseHandle?
    private var ideasDeleteRefHandle: FIRDatabaseHandle?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Config.showDetails, let detailsViewController = segue.destination as? IdeaDetailsTableViewController, let index = sender as? Int else {
            return
        }
        
        if searchActive && filteredIdeas.count > index {
            detailsViewController.setIdea(filteredIdeas[index])
        } else {
            detailsViewController.setIdea(ideas.retrieveIdeaAt(index: index))
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        setUpIdeaListTableView()
        setUpLayout()
        ideasRef = System.client.getIdeasRef()
        observeIdeas()
    }
    
    private func setUpIdeaListTableView() {
        ideaListTableView.dataSource = self
        ideaListTableView.delegate = self
    }
    
    private func setUpLayout() {
        if System.activeUser?.type.isParticipant == false {
            self.navigationItem.rightBarButtonItem = nil
        }
        
        Utility.setUpSearchBar(searchBar, viewController: self, selector: #selector(donePressed))
        Utility.styleSearchBar(searchBar)
    }
    
    @objc private func donePressed() {
        self.view.endEditing(true)
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
            let indexPath = [IndexPath(row: index, section: Config.defaultSection)]
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
            present(Utility.getFailAlertController(message: Config.ideaCreateErrorMessage), animated: true, completion: nil)
            return
        }
        performSegue(withIdentifier: Config.addIdea, sender: nil)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Config.ideaItemCell, for: indexPath) as? IdeaItemTableViewCell else {
            return UITableViewCell()
        }
        
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
        return Config.ideaListTableCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Config.showDetails, sender: indexPath.row)
    }

}

// MARK: UISearchResultsUpdating
extension IdeasListTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredIdeas = ideas.getAllIdeas().filter { idea in
            return idea.name.lowercased().contains(searchText.lowercased())
        }
        
        Utility.setSearchActive(&searchActive, searchBar: searchBar)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        Utility.setSearchActive(&searchActive, searchBar: searchBar)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        Utility.setSearchActive(&searchActive, searchBar: searchBar)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        Utility.setSearchActive(&searchActive, searchBar: searchBar)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Utility.setSearchActive(&searchActive, searchBar: searchBar)
        Utility.searchBtnPressed(viewController: self)
    }
}
