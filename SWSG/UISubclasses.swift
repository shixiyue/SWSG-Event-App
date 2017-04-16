//
//  UISubclasses.swift
//  SWSG
//
//  Created by shixiyue on 14/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

/**
 PlaceholderTextView is a UITextView, inherits from UITextView.
 
 It supports placeholder.
 */
class PlaceholderTextView: UITextView {
    
    var isEmpty: Bool {
        return textColor == UIColor.lightGray || text.isEmpty
    }
    
    var content: String! {
        guard !isEmpty, let content = text?.trimTrailingWhiteSpace(), !content.isEmpty else {
            return Config.defaultContent
        }
        return content
    }
    
    private var placeholder: String = Config.emptyString
    
    func setPlaceholder(_ placeholder: String) {
        self.placeholder = placeholder
        setPlaceholder()
    }
    
    func setPlaceholder() {
        textColor = Config.placeholderColor
        text = placeholder
        selectedTextRange = textRange(from: beginningOfDocument, to: beginningOfDocument)
    }
    
    func removePlaceholder() {
        text = nil
        textColor = UIColor.black
    }
    
}

/**
GrayBorderTextView is a PlaceholderTextView with gray border.
 */
class GrayBorderTextView: PlaceholderTextView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.borderColor = Config.grayBorderColor
        layer.borderWidth = Config.borderWidth
        layer.cornerRadius = Config.cornerRadius
    }
    
}

/**
 RoundCornerButton is a round corner UIButton.
 */
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

/**
 RoundButton is a round UIButton.
 */
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
