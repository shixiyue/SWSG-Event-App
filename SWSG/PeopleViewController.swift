//
//  PeopleViewController.swift
//  SWSG
//
//  Created by Shi Xiyue on 26/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var people: [(name: String, title: String, intro: String, photo: String)]!
    var header: String!

    @IBOutlet var peopleTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setUpTableView() {
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
        cell.name.text = person.name
        cell.title.text = person.title
        cell.intro.text = person.intro
        cell.photo.image = UIImage(named: person.photo)
        return cell
    }
    
}
