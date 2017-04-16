//
//  OverviewViewController.swift
//  SWSG
//
//  Created by Shi Xiyue on 25/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class TemplateViewController: UITableViewController {

    @IBOutlet private var overviewTableView: UITableView!
    @IBOutlet private var overviewText: UILabel!
    @IBOutlet private var video: UIWebView!
    
    private var content: TemplateContent!
    private var isScrollEnabled: Bool!
    private var photoPageViewController: PhotoPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpOverviewTableView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "images", let photoPageViewController = segue.destination as? PhotoPageViewController else {
            return
        }
        photoPageViewController.images = content.images
        self.photoPageViewController = photoPageViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUp()
    }
    
    private func setUpOverviewTableView() {
        overviewTableView.tableFooterView = UIView(frame: CGRect.zero)
        overviewTableView.allowsSelection = false
        overviewTableView.isScrollEnabled = false
        overviewTableView.layoutIfNeeded()
    }
    
    func presetInfo(content: TemplateContent) {
        self.content = content
    }
    
    func setUp() {
        loadYoutube()
        overviewText.text = content.description
        updateImages()
        overviewTableView.reloadData()
    }
    
    func updateImages() {
        photoPageViewController.images = content.images
        photoPageViewController.setUpPageViewController()
        overviewTableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 1 && content.images.count == 0) || (indexPath.row == 2 && content.videoLink.isEmpty) {
            return 0
        }
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    private func loadYoutube() {
        guard let youtubeURL = URL(string: content.videoLink) else {
            return
        }
        video.loadRequest(URLRequest(url: youtubeURL))
    }

}
