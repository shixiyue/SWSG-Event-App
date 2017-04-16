//
//  TagTableViewCell.swift
//  SWSG
//
//  Created by Li Xiaowei on 4/9/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

/**
 TagTableViewCell inherits from UITableViewCell, it is responsible for displaying all tags in a collectionview
 
 -Parameter: `tagCollectionView` a mutable UICollectionView object which displays all tags
 */

import UIKit

class TagTableViewCell: UITableViewCell {

    @IBOutlet weak var tagCollectionView: UICollectionView!
    
}
