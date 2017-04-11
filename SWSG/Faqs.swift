//
//  FaqInfo.swift
//  SWSG
//
//  Created by Shi Xiyue on 27/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation

class Faqs {
    
    var faq: [Faq]
    
    init() {
        faq = []
        let first = Faq(question: "What is the venue?", answer: "Google Asia Pacific | Mapletree Business City\n\n70, Pasir Panjang Road\n\nSingapore, Singapore 117371")
        let second = Faq(question: "Who make the app?", answer: "CS3217-10, Team SWSG :)")
        faq.append(first)
        faq.append(second)
        System.client.saveInformation(faq: first, completion: { (_) in })
        System.client.saveInformation(faq: second, completion: { (_) in })
    }
    
}
