//
//  CommentsInputTableViewCell.swift
//  SWSG
//
//  Created by Li Xiaowei on 3/17/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class CommentsInputTableViewCell: UITableViewCell {
    
    @IBOutlet weak var commentInputField: UITextField!
   
    @IBAction func onAddCommentButtonClick(_ sender: Any) {
        var comment = Comments.comments[EventDetailsTableViewController.event!.name]
        if comment != nil {
            comment!.append(Comment(words: commentInputField.text!,username: Config.currentLogInUser))
            
        } else {
            comment = [Comment(words: commentInputField.text!,username: Config.currentLogInUser)]
        }
        Comments.comments.updateValue(comment!, forKey: EventDetailsTableViewController.event!.name)
        commentInputField.text = ""
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

