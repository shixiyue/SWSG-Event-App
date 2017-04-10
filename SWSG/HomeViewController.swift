//
//  ViewController.swift
//  SWSG
//
//  Created by Jeremy Jee on 9/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import SwiftSpinner

class HomeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SwiftSpinner.hide()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

