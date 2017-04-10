//
//  CommentsInputTableViewCell.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/17/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class CommentsInputTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var commentInputField: GrayBorderTextView!
    var event: Event?
    
    @IBAction func onAddCommentButtonClick(_ sender: Any) {
        guard let user = System.activeUser, let id = user.uid,
            let text = commentInputField.text, let event = event else {
            return
        }
        
        let comment = Comment(authorID: id, text: text)
        System.client.addComment(event, comment: comment, completion: { (error) in
            self.commentInputField.text = ""
        })
        
        var size = commentInputField.sizeThatFits(CGSize(width: commentInputField.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        guard size.height != commentInputField.frame.size.height else {
            return
        }
        size.width = size.width > commentInputField.frame.size.width ? size.width : commentInputField.frame.size.width
        commentInputField.frame.size = size
    }
    
}

extension CommentsInputTableViewCell: UITextViewDelegate {
    
    func updateButtonState() {
        guard var text = commentInputField.text else {
            return
        }
        
        text = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if text.characters.count > 0 {
            addBtn.isEnabled = true
        } else {
            addBtn.isEnabled = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        updateButtonState()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard let textView = textView as? PlaceholderTextView, let currentText = textView.text else {
            return false
        }
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if updatedText.isEmpty {
            textView.setPlaceholder()
            updateButtonState()
            return false
        } else if textView.textColor == Config.placeholderColor && !text.isEmpty {
            textView.removePlaceholder()
            updateButtonState()
        }
        return true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        guard textView.textColor == Config.placeholderColor else {
            return
        }
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
    }
}

