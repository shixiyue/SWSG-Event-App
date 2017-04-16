//
//  PeopleViewController.swift
//  SWSG
//
//  Created by Shi Xiyue on 26/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import Firebase

class PeopleViewController: FullScreenImageViewController {
    
    var category: String!
    
    @IBOutlet fileprivate var peopleTableView: UITableView!
    
    fileprivate var people = People.getPeopleInstance()
    fileprivate var peopleInCategory: [Person]!

    private var peopleRef: FIRDatabaseReference?
    private var peopleAddRefHandle: FIRDatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        peopleRef = System.client.getPeopleRef(for: category)
        observePeople()
        setUpTableView()
    }
    
    private func observePeople() {
        guard let peopleRef = peopleRef else {
            return
        }
        
        peopleAddRefHandle = peopleRef.observe(.childAdded, with: { (snapshot) -> Void in
            DispatchQueue.main.async {
                self.people.add(category: self.category, snapshot: snapshot)
                self.peopleTableView.reloadData()
                self.loadImages()
            }
        })
    }
    
    private func loadImages() {
        for person in people.retrievePerson(category: category) {
            person.loadImage(completion: { (needRefresh) in
                guard needRefresh else {
                    return
                }
                DispatchQueue.main.async {
                    self.peopleTableView.reloadData()
                }
            })
        }
    }
    
    private func setUpTableView() {
        peopleTableView.dataSource = self
        peopleTableView.delegate = self
        peopleTableView.tableFooterView = UIView(frame: CGRect.zero)
        peopleTableView.allowsSelection = false
    }
    
    deinit {
        if let addHandle = peopleAddRefHandle {
            peopleRef?.removeObserver(withHandle: addHandle)
        }
    }
}

extension PeopleViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        peopleInCategory = people.retrievePerson(category: category)
        return peopleInCategory.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.item
        guard index != 0 else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Config.informationHeaderCell, for: indexPath) as? InformationHeaderTableViewCell else {
                return InformationHeaderTableViewCell()
            }
            cell.setHeader(category)
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Config.personCell, for: indexPath) as? PeopleTableViewCell else {
            return PeopleTableViewCell()
        }
        let person = peopleInCategory[index - 1]
        cell.setUp(person: person)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showFullScreenImage as (UITapGestureRecognizer) -> Void))
        cell.addGestureRecognizer(tapGesture)
        return cell
    }
    
}
