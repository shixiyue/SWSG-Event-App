//
//  FaqTableViewCell.swift
//  SWSG
//
//  Created by Shi Xiyue on 27/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

/**
 FaqTableViewCell is a UITableViewCell that is used in FaqViewController
 to display information about a faq.
 
 It has an Answer Label, a Question Label, an a Link String?.
 */
class FaqTableViewCell: UITableViewCell {

    @IBOutlet var question: UILabel!
    @IBOutlet var answer: UILabel!
    
    private var link: String?
    
    func setUp(question: String, answer: String, link: String?) {
        self.question.text = question
        self.answer.text = answer
        self.link = link
        guard link != nil else {
            return
        }
        self.answer.textColor = Config.blueColor
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openLink))
        self.answer.addGestureRecognizer(tapGestureRecognizer)
        self.answer.isUserInteractionEnabled = true
    }
    
    @objc private func openLink() {
        guard let link = link else {
            return
        }
        guard let url = URL(string: link) else {
            return
        }
        UIApplication.shared.open(url)
    }
    
}
