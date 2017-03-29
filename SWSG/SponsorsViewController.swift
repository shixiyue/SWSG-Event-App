//
//  SponsorsViewController.swift
//  SWSG
//
//  Created by Shi Xiyue on 27/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class SponsorsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet private var sponsorsTableView: UITableView!
    var sponsors: [(title: String, list: [(image: String, link: String)])]  { return SponsorsInfo.sponsors }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSponsorsTableView()
    }
    
    private func setUpSponsorsTableView() {
        sponsorsTableView.dataSource = self
        sponsorsTableView.delegate = self
        sponsorsTableView.tableFooterView = UIView(frame: CGRect.zero)
        sponsorsTableView.allowsSelection = false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 1
        for tuple in sponsors {
            count += 1 + Int(ceil(Double(tuple.list.count) / 3))
        }
        return count
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
            cell.informationHeader.text = "Sponsors"
            return cell
        }
        var count = 1
        var titleIndex = 0
        for tuple in sponsors {
            if count == index {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath) as? SponsorsTitleTableViewCell else {
                    return SponsorsTitleTableViewCell()
                }
                cell.title.text = tuple.title
                return cell
            }
            count += 1
            titleIndex += 1
            guard index < count + Int(ceil(Double(tuple.list.count) / 3)) else {
                count += Int(ceil(Double(tuple.list.count) / 3))
                continue
            }
            var sponsorIndex = (index - count) * 3
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "sponsorsCell", for: indexPath) as? SponsorsTableViewCell else {
                return UITableViewCell()
            }
            cell.firstImage.image = UIImage(named: tuple.list[sponsorIndex].image)
            cell.firstLink = tuple.list[sponsorIndex].link
            sponsorIndex += 1
            if sponsorIndex >= tuple.list.count {
                return cell
            }
            cell.secondImage.image = UIImage(named: tuple.list[sponsorIndex].image)
            cell.secondLink = tuple.list[sponsorIndex].link
            sponsorIndex += 1
            if sponsorIndex >= tuple.list.count {
                return cell
            }
            cell.thirdImage.image = UIImage(named: tuple.list[sponsorIndex].image)
            cell.thirdLink = tuple.list[sponsorIndex].link
            return cell
        }
        return UITableViewCell()
    }
}
