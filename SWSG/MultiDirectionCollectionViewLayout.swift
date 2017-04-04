//
//  MultiDirectionCollectionViewLayout.swift
//  SWSG
//
//  Created by Jeremy Jee on 3/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//  Code from: https://www.credera.com/blog/mobile-applications-and-web/building-a-multi-directional-uicollectionview-in-swift/

import UIKit

class MultiDirectionCollectionViewLayout: UICollectionViewLayout {

    let CELL_HEIGHT = 50.0
    let CELL_WIDTH = 50.0
    
    var cellAttrDict = [IndexPath: UICollectionViewLayoutAttributes]()
    var contentSize = CGSize.zero
    
    var dataSourceDidUpdate = true
    
    override var collectionViewContentSize: CGSize {
        return self.contentSize
    }
    
    override func prepare() {
        guard let collectionView = collectionView, dataSourceDidUpdate else {
            return
        }
        
        dataSourceDidUpdate = false
        
        // Cycle through each section of the data source.
        if collectionView.numberOfSections > 0 {
            for section in 0...collectionView.numberOfSections - 1 {
                
                // Cycle through each item in the section.
                if collectionView.numberOfItems(inSection: section) > 0 {
                    for item in 0...collectionView.numberOfItems(inSection: section) - 1 {
                        
                        // Build the UICollectionVieLayoutAttributes for the cell.
                        let cellIndex = IndexPath(item: item, section: section)
                        let xPos = Double(item) * CELL_WIDTH
                        let yPos = Double(section) * CELL_HEIGHT
                        
                        let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex)
                        cellAttributes.frame = CGRect(x: xPos, y: yPos, width: CELL_WIDTH, height: CELL_HEIGHT)
                        
                        // Determine zIndex based on cell type.
                        if section == 0 && item == 0 {
                            cellAttributes.zIndex = 4
                        } else if section == 0 {
                            cellAttributes.zIndex = 3
                        } else if item == 0 {
                            cellAttributes.zIndex = 2
                        } else {
                            cellAttributes.zIndex = 1
                        }
                        
                        // Save the attributes.
                        cellAttrDict[cellIndex] = cellAttributes
                        
                    }
                }
                
            }
        }
        
        // Update content size.
        let contentWidth = Double(collectionView.numberOfItems(inSection: 0)) * CELL_WIDTH
        let contentHeight = Double(collectionView.numberOfSections) * CELL_HEIGHT
        self.contentSize = CGSize(width: contentWidth, height: contentHeight)
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        // Create an array to hold all elements found in our current view.
        var attributesInRect = [UICollectionViewLayoutAttributes]()
        
        // Check each element to see if it should be returned.
        for cellAttributes in cellAttrDict.values {
            if rect.intersects(cellAttributes.frame) {
                attributesInRect.append(cellAttributes)
            }
        }
        
        // Return list of elements.
        return attributesInRect
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttrDict[indexPath]!
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}
