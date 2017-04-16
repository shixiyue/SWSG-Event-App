//
//  InformationViewController.swift
//  SWSG
//
//  Created by Shi Xiyue on 25/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

/**
 InformationViewController is a UIViewController, inherits from BaseViewController
 for the menu, that displays a list of all categories of information.
 
 It allows the user to navigate to different information.
 */
class InformationViewController: BaseViewController {
    
    @IBOutlet private var informationTable: UITableView!
    
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
        guard let identifier = segue.identifier,
            let peopleViewController = segue.destination as? PeopleViewController else {
            return
        }
        switch identifier {
        case Config.speakers, Config.judges, Config.organizers:
            peopleViewController.category = identifier
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
        return Config.informationItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.item
        let item =  Config.informationItems[index]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Config.informationCell,
                                                       for: indexPath) as? InformationCell else {
            return InformationCell()
        }
        
        cell.setUp(name: item.name, icon: item.image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = Config.informationItems[indexPath.row]
        performSegue(withIdentifier: item.name, sender: nil)
    }
    
}
