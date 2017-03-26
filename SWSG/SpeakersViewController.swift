//
//  SpeakersViewController.swift
//  SWSG
//
//  Created by Shi Xiyue on 26/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class SpeakersViewController: UIViewController {

    @IBOutlet private var speakersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSpeakersTableView()
    }
    
    private func setUpSpeakersTableView() {
        speakersTableView.dataSource = self
        speakersTableView.delegate = self
        speakersTableView.tableFooterView = UIView(frame: CGRect.zero)
        speakersTableView.allowsSelection = false
    }

}

extension SpeakersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SpeakersInfo.speakers.count + 1
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
            cell.informationHeader.text = "Speakers"
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "speakersCell", for: indexPath) as? SpeakersTableViewCell else {
            return SpeakersTableViewCell()
        }
        let speaker = SpeakersInfo.speakers[index - 1]
        cell.speakerName.text = speaker.name
        cell.speakerTitle.text = speaker.title
        cell.speakerIntro.text = speaker.intro
        cell.speakerPhoto.image = UIImage(named: speaker.photo)
        return cell
    }
    
}

