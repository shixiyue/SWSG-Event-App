//
//  Event.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/16/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

protocol Event {
    
    var image: UIImage { get set }
    var date_time: Date { get set }
    var venue: String { get set }
    var description: String { get set }
    var details: String { get set }
    
}
