//
//  SponsorsInfo.swift
//  SWSG
//
//  Created by Shi Xiyue on 27/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//
/*
import Firebase

class Sponsors {
    
    private var sponsors =  [String: [Sponsor]]()
    
    func add(snapshot: FIRDataSnapshot) {
        guard let snapshotValue = snapshot.value as? [String: String] else {
            return
        }
        guard let title = snapshotValue[Config.title] else {
            return
        }
        guard let sponsor = Sponsor(snapshotValue: snapshotValue) else {
            return
        }
        var sponsorInSameCategory = sponsors[title] ?? []
        guard sponsorInSameCategory.index(of: sponsor) == nil else {
            return
        }
        sponsorInSameCategory.append(sponsor)
        sponsors[title] = sponsorInSameCategory.sorted(by: {$0.name < $1.name})
    }
    
    func retrieveSponsors() -> [String: [Sponsor]] {
        return sponsors
    }
    
}*/
