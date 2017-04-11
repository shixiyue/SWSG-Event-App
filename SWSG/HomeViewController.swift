//
//  ViewController.swift
//  SWSG
//
//  Created by Jeremy Jee on 9/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import Firebase
import SwiftSpinner

class HomeViewController: BaseViewController {

    @IBOutlet weak var eventsView: UIView!
    @IBOutlet weak var eventPageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SwiftSpinner.hide()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Config.eventPageEmbed,
            let eventPageVC = segue.destination as? EventPageViewController {
            eventPageVC.eventDelegate = self
        }
    }
    
}

extension HomeViewController: EventPageViewControllerDelegate {
    func eventPageViewController(_ eventPageViewController: EventPageViewController,
                                    didUpdatePageCount count: Int) {
        eventPageControl.numberOfPages = count
    }
    
    func eventPageViewController(_ eventPageViewController: EventPageViewController,
                                    didUpdatePageIndex index: Int) {
        eventPageControl.currentPage = index
    }
    
}
