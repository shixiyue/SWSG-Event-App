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
        Comments.comments.append(Comment(words: commentInputField.text!))
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

