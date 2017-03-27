//
//  OverviewViewController.swift
//  SWSG
//
//  Created by Shi Xiyue on 25/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class OverviewViewController: UITableViewController {

    @IBOutlet private var overviewTableView: UITableView!
    @IBOutlet private var overviewText: UILabel!
    @IBOutlet private var video: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpOverviewTableView()
        overviewText.text = OverviewContent.description
        loadYoutube()
    }

    private func setUpOverviewTableView() {
        overviewTableView.tableFooterView = UIView(frame: CGRect.zero)
        overviewTableView.allowsSelection = false
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    private func loadYoutube() {
        guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(OverviewContent.videoID)") else {
            return
        }
        video.loadRequest(URLRequest(url: youtubeURL))
    }

}

