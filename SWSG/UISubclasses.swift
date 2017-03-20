//
//  UISubclasses.swift
//  SWSG
//
//  Created by shixiyue on 14/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class GrayBorderTextView: UITextView {
    
    private var placeholder: String = ""
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 5.0
    }
    
    func setPlaceholder(_ placeholder: String) {
        self.placeholder = placeholder
        setPlaceholder()
    }
    
    func setPlaceholder() {
        textColor = UIColor.lightGray
        text = placeholder
    }
    
    func removePlaceholder() {
        text = nil
        textColor = UIColor.black
    }
    
}

class RoundCornerButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = Config.buttonCornerRadius
        clipsToBounds = true
        titleLabel?.font = Config.defaultButtonFont
    }
    
    func setDisable() {
        isEnabled = false
        alpha = Config.disableAlpha
    }
    
}

class RoundButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = frame.size.width / 2
        clipsToBounds = true
    }
}

class CropAreaView: UIView {

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }
}
