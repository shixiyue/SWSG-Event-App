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
            count += 1 + Int(ceil(Double(tuple.list.count) / Config.numOfSponsorsInRow))
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
            return getSponsorsHeaderCell(indexPath: indexPath)
        }
        var count = 1
        var titleIndex = 0
        for tuple in sponsors {
            if count == index {
                return getSponsorTitleTabelViewCell(indexPath: indexPath, title: tuple.title)
            }
            count += 1
            titleIndex += 1
            guard index < count + Int(ceil(Double(tuple.list.count) / Config.numOfSponsorsInRow)) else {
                count += Int(ceil(Double(tuple.list.count) / Config.numOfSponsorsInRow))
                continue
            }
            return getSponsorsTableViewCell(indexPath: indexPath, index: index, count: count, list: tuple.list)
        }
        return UITableViewCell()
    }
    
    private func getSponsorsHeaderCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = sponsorsTableView.dequeueReusableCell(withIdentifier: Config.informationHeaderCell, for: indexPath) as? InformationHeaderTableViewCell else {
            return InformationHeaderTableViewCell()
        }
        cell.setHeader(Config.sponsorsHeader)
        return cell
    }
    
    private func getSponsorTitleTabelViewCell(indexPath: IndexPath, title: String) -> UITableViewCell {
        guard let cell = sponsorsTableView.dequeueReusableCell(withIdentifier: Config.titleCell, for: indexPath) as? SponsorsTitleTableViewCell else {
            return SponsorsTitleTableViewCell()
        }
        cell.setTitle(title)
        return cell
    }
    
    private func getSponsorsTableViewCell(indexPath: IndexPath, index: Int, count: Int, list: [(image: String, link: String)]) -> UITableViewCell {
        var sponsorIndex = (index - count) * Int(Config.numOfSponsorsInRow)
        guard let cell = sponsorsTableView.dequeueReusableCell(withIdentifier: Config.sponsorsCell, for: indexPath) as? SponsorsTableViewCell else {
            return UITableViewCell()
        }
        cell.setFirst(image: UIImage(named: list[sponsorIndex].image), link: list[sponsorIndex].link)
        sponsorIndex += 1
        if sponsorIndex >= list.count {
            return cell
        }
        cell.setSecond(image: UIImage(named: list[sponsorIndex].image), link: list[sponsorIndex].link)
        sponsorIndex += 1
        if sponsorIndex >= list.count {
            return cell
        }
        cell.setThird(image: UIImage(named: list[sponsorIndex].image), link: list[sponsorIndex].link)
        return cell
    }
    
}
