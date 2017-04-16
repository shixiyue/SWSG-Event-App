//
//  OverviewViewController.swift
//  SWSG
//
//  Created by Shi Xiyue on 2/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

/**
 OverviewViewController is a UIViewController that displays the information
 for a overview content.
 
 Specifications:
 - overview: OverviewContent whose information to display
 */
class OverviewViewController: FullScreenImageTableViewController {
    
    // MARK: Properties
    private var overview = OverviewContent() // Placeholder
    
    private var containerViewController: TemplateViewController!
    fileprivate var containerHeight: CGFloat!
    private var editButton: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        observeOverviewContent()
    }
    
    // MARK: Observer Overview Content
    private func observeOverviewContent() {
        let overviewRef = System.client.getOverviewRef()
        overviewRef.observeSingleEvent(of : .value, with : {(snapshot) in
            self.overview = OverviewContent(snapshot: snapshot)
            self.containerViewController.presetInfo(content: self.overview)
            self.containerViewController.setUp()
            self.updateCellHeight()
            self.loadOverviewImages()
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Config.container, let containerViewController = segue.destination as? TemplateViewController {
            containerViewController.presetInfo(content: self.overview)
            containerViewController.tableView.layoutIfNeeded()
            containerHeight = containerViewController.tableView.contentSize.height
            self.containerViewController = containerViewController
        } else if segue.identifier == Config.edit, let editViewController = segue.destination as? OverviewEditViewController {
            editViewController.overview = overview
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        containerViewController.setUp()
        updateCellHeight()
    }
    
    private func updateCellHeight() {
        DispatchQueue.main.async {
            self.containerViewController.tableView.layoutIfNeeded()
            self.containerHeight = self.containerViewController.tableView.contentSize.height
            self.tableView.reloadData()
        }
    }
    
    private func loadOverviewImages() {
        guard !overview.imagesState.imagesHasFetched, let id = overview.id else {
            return
        }
        if let edit = editButton {
            edit.isEnabled = false
        }
        NotificationCenter.default.addObserver(self, selector: #selector(updateImages), name: Notification.Name(rawValue: id), object: nil)
        overview.loadImages()
    }
    
    @objc private func updateImages(_ notification: NSNotification) {
        containerViewController.updateImages()
        updateCellHeight()
        if let edit = editButton {
            edit.isEnabled = true
        }
    }
    
    private func setNavigationBar() {
        guard let user = System.activeUser, user.type.isOrganizer else {
            return
        }
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(jumpToEdit))
        self.editButton = edit
        navigationItem.rightBarButtonItems = [edit]
    }
    
    @objc private func jumpToEdit() {
        performSegue(withIdentifier: Config.edit, sender: self)
    }

}

// MARK: UITableViewDelegate
extension OverviewViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case Config.overviewContainerIndex: return containerHeight
        default: return Config.defaultTableHeight
        }
    }
    
}

