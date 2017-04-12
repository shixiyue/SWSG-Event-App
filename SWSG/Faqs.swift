//
//  FaqInfo.swift
//  SWSG
//
//  Created by Shi Xiyue on 27/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Firebase

class Faqs {
    
    private var faqs: [Faq] = []
    
    func add(snapshot: FIRDataSnapshot) {
        guard let snapshotValue = snapshot.value as? [String: String] else {
            return
        }
        guard let faq = Faq(snapshotValue: snapshotValue) else {
            return
        }
        faqs.append(faq)
        faqs = faqs.sorted(by: {
            guard let firstId = $0.id, let secondId = $1.id else {
                return false
            }
            return firstId < secondId
        })
    }
    
    func retrieveFaqs() -> [Faq] {
        return faqs
    }
    
}
