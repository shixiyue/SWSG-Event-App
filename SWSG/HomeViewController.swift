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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SwiftSpinner.hide()
    }
    
}
