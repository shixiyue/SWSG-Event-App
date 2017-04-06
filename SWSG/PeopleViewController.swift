//
//  PeopleViewController.swift
//  SWSG
//
//  Created by Shi Xiyue on 26/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class PeopleViewController: FullScreenImageViewController, UITableViewDataSource, UITableViewDelegate {
    
    var people: [Person]!
    var header: String!

    @IBOutlet var peopleTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    private func setUpTableView() {
        peopleTableView.dataSource = self
        peopleTableView.delegate = self
        peopleTableView.tableFooterView = UIView(frame: CGRect.zero)
        peopleTableView.allowsSelection = false
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count + 1
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "informationHeaderCell", for: indexPath) as? InformationHeaderTableViewCell else {
                return InformationHeaderTableViewCell()
            }
            cell.informationHeader.text = header
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as? PeopleTableViewCell else {
            return PeopleTableViewCell()
        }
        let person = people[index - 1]
        cell.setUp(person: person)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showFullScreenImage as (UITapGestureRecognizer) -> Void))
        cell.addGestureRecognizer(tapGesture)
        return cell
    }
    
}
