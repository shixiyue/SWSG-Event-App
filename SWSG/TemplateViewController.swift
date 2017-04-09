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
    
    private var desc: String!
    private var images: [UIImage]!
    private var videoLink: String!
    private var isScrollEnabled: Bool!
    private var photoPageViewController: PhotoPageViewController!
    
    func presetInfo(desc: String, images: [UIImage], videoLink: String, isScrollEnabled: Bool) {
        self.desc = desc
        self.images = images
        self.videoLink = videoLink
        self.isScrollEnabled = isScrollEnabled
    }
    
    func updateImages(images: [UIImage]) {
        self.images = images
        photoPageViewController.images = images
        photoPageViewController.setUpPageViewController()
        overviewTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "images", let photoPageViewController = segue.destination as? PhotoPageViewController else {
            return
        }
        photoPageViewController.images = images
        self.photoPageViewController = photoPageViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpOverviewTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUp()
    }
    
    func setUp() {
        photoPageViewController.images = images
        photoPageViewController.setUpPageViewController()
        loadYoutube()
        overviewText.text = desc
        overviewTableView.reloadData()
    }

    private func setUpOverviewTableView() {
        overviewTableView.tableFooterView = UIView(frame: CGRect.zero)
        overviewTableView.allowsSelection = false
        overviewTableView.isScrollEnabled = isScrollEnabled
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 1 && images.count == 0) || (indexPath.row == 2 && videoLink.isEmpty) {
            return 0
        }
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    private func loadYoutube() {
        guard let youtubeURL = URL(string: videoLink) else {
            return
        }
        video.loadRequest(URLRequest(url: youtubeURL))
    }

}
