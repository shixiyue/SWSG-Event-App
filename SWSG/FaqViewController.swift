//
//  FaqViewController.swift
//  SWSG
//
//  Created by Shi Xiyue on 27/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class FaqViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var faqTableView: UITableView!
    var faq = Faqs().faq

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFaqTableView()
    }
    
    private func setUpFaqTableView() {
        faqTableView.dataSource = self
        faqTableView.delegate = self
        faqTableView.tableFooterView = UIView(frame: CGRect.zero)
        faqTableView.allowsSelection = false
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faq.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.item
        guard index != 0 else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "informationHeaderCell", for: indexPath) as? InformationHeaderTableViewCell else {
                return InformationHeaderTableViewCell()
            }
            cell.informationHeader.text = "Frequently Asked Questions"
            return cell
        }
        return FaqTableViewCell()
        /*guard let cell = tableView.dequeueReusableCell(withIdentifier: "faqCell", for: indexPath) as? FaqTableViewCell else {
            return FaqTableViewCell()
        }
        let questionAnswer = faq[index - 1]
        cell.question.text = questionAnswer.question
        cell.answer.text = questionAnswer.answer
        return cell*/
    }
    
}
