//
//  InformationViewController.swift
//  SWSG
//
//  Created by Shi Xiyue on 25/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class InformationViewController: BaseViewController {
    
    @IBOutlet private var informationTable: UITableView!
    
    fileprivate let informationItems: [(name: String, image: String)] = [("Overview", "Overview"), ("Speakers", "Speakers"), ("Judges", "Judges"), ("Sponsors", "Sponsors"), ("Organizing Team", "Organizers"), ("Frequently Asked Questions", "Questions")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        addSlideMenuButton()
    }
    
    private func setUpTable() {
        informationTable.delegate = self
        informationTable.dataSource = self
        informationTable.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier, let peopleViewController = segue.destination as? PeopleViewController else {
            return
        }
        switch identifier {
        case "Speakers":
            peopleViewController.people = SpeakersInfo.speakers
            peopleViewController.header = "Speakers"
        case "Judges":
            peopleViewController.people = JudgesInfo.judegs
            peopleViewController.header = "Judges"
        case "Organizing Team":
            peopleViewController.people = OrganizersInfo.organizers
            peopleViewController.header = "Organizing Team"
        default:
            return
        }
    }
    
}

extension InformationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return informationItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.item
        let item =  informationItems[index]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "informationCell", for: indexPath) as? InformationCell else {
            return InformationCell()
        }
        
        cell.icon.image = UIImage(named: item.image)
        cell.name.text = item.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = informationItems[indexPath.row]
        performSegue(withIdentifier: item.name, sender: nil)
    }
    
}
