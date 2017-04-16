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

/**
    HomeViewController is a UIViewController, inherits from BaseViewController
    for the menu, and contains two other Views EventPageViewController and
    ChannelPageViewController
 */

class HomeViewController: BaseViewController {

    @IBOutlet weak var eventsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SwiftSpinner.hide()
    }
    
}
