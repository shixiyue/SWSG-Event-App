//
//  CommentsInputTableViewCell.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/17/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class CommentsInputTableViewCell: UITableViewCell {
    
    @IBOutlet weak var commentInputField: GrayBorderTextView!
   
    @IBAction func onAddCommentButtonClick(_ sender: Any) {
        /*var comment = Comments.comments[EventDetailsTableViewController.event!.name]
        if comment != nil {
            comment!.append(Comment(words: commentInputField.content,username: System.activeUser!.profile.name))
            
        } else {
            comment = [Comment(words: commentInputField.content,username: System.activeUser!.profile.name)]
        }
        Comments.comments.updateValue(comment!, forKey: EventDetailsTableViewController.event!.name)
        commentInputField.text = ""
        var size = commentInputField.sizeThatFits(CGSize(width: commentInputField.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        guard size.height != commentInputField.frame.size.height else {
            return
        }
        size.width = size.width > commentInputField.frame.size.width ? size.width : commentInputField.frame.size.width
        commentInputField.frame.size = size*/
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

