//
//  Person.swift
//  SWSG
//
//  Created by Shi Xiyue on 6/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation

class People {
    
    private var people = [String: [Person]]()
    private static var sharedInstance = People()
    
    private init() {
        // Temporary
        let speakers = [Person(photo: UIImage(named: "BryanLong"), name: "Bryan Long", title: "Co-founder & CEO, Stacck", intro: "Bryan Long is the co-founder of Stacck, a startup that automate instructions for service industry employees. He has raised more than a million dollars in funding by applying lean startup principles. Bryan is also the founder of The Testing Ground and the President of the Association of Lean Startups which organises the Singapore Lean Startup Circle. He is a fervent evangelist of Lean Startup and has mentored numerous startups in Singapore and SE Asia through various Lean Startup events and engagements."),
                        Person(photo: UIImage(named: "DanielThong"), name: "Daniel Thong", title: "Country Manager, Singapore, ServisHero", intro: "Daniel is the youngest country manager and co-founder of ServisHero Singapore, a mobile-first platform that links consumers with local service providers like plumbers, electricians and cleaners. As one of South East Asia’s fastest growing start-ups, ServisHero has been hailed as the ‘Grab’ equivalent for local services. The app is now live in 5 different cities in Thailand, Malaysia and Singapore and it operates in 6 cities growing at a rapid pace.\n\nDaniel is in charge of executing ServisHero’s go-to-market strategy here in Singapore, scaling its business operations and growing its market share.\n\nDaniel graduated from the University of Oxford in 2014 with a Masters (Distinction) in Social and Economic History and a BSc in Philosophy and Economics (First-Class Honours) at the London School of Economics.\n\nHe likes a good cup of coffee and a good conversation and is interested in meeting people passionate about UX and product design.")]
        
        people[Config.speakers] = speakers
        
        let judges = [Person(photo: UIImage(named: "VishalHarnal"), name: "Vishal Harnal", title: "Partner, 500 Startups", intro: "Vishal is a Partner at 500 Startups, a global venture capital firm and accelerator headquartered in Silicon Valley. Based in Singapore, Vishal leads and scales 500’s investments and operations across South-East Asia through the regional-focused Durians fund. In the past two years, 500 has become the most active early-stage investor in the region with over 120 investments into the most talented, passionate founders and promising, high-growth startups including flagships Grab, Carousell, Bukalapak, KFit and 99.co. Prior to joining 500, Vishal practiced law in Asia’s top dispute resolution team at Drew & Napier, where he represented conglomerates and governments on some of the world’s most complex, high-stakes and sensitive commercial and political issues and disputes."),
                      Person(photo: UIImage(named: "ArthurBrejon"), name: "Arthur Brejon", title: "Co-founder, COO - Lazada.sg", intro: "As co-founder, Arthur is the driving force for the Lazada Singapore business and is responsible for overall operations of the business which encompasses supply chain & logistics, product management and customer service. He is also a geek and entrepreneurship enthusiast who likes helping startups during his free time.\n\nArthur began his career at BNP Paribas’s Investment Banking division working closely with corporate, institutional and hedge funds clients in the capital markets division.\n\nArthur then joined Rocket Internet where he held several senior positions in the group: Regional Marketing manager, Head of Deals & Partnerships for SEA, Head of Business Management & Payments, before taking on the role of Chief Product Officer at Lazada and now Co-founder of the Singapore business.\n\nArthur graduated with a Master’s degree in Banking & Finance from the University of Paris Dauphine and holds an MBA from the University of Pantheon-Assas in Paris.")]
        
        people[Config.judges] = judges
        
        let organizers = [Person(photo: UIImage(named: "DurwinHo"), name: "Durwin Ho", title: "Entrepreneur", intro: "Durwin is passionate about startups and entrepreneurship, especially in technology, F&B, education and AI. Besides running his family business in the childcare industry, he is a budding designer and avid marketing strategist."),
                         Person(photo: UIImage(named: "LalithaWemel"), name: "Lalitha Wemel", title: "Regional Manager, Techstars", intro: "Lalitha Wemel is a community architect based in Kuala Lumpur, Malaysia. She is incredibly passionate about fostering entrepreneurship, grassroots leadership, and strong communities. Lalitha has been involved in various startup projects and communities for the better part of the last decade, both in and out of Malaysia. She has a deep love for eloquent minds, adventure, coffee, and travel. She is currently the Regional Manager for Techstars Startup Programs across South East Asia and Oceania, where she works with amazing community leaders to strengthen and empower their local startup ecosystem.")]
        
        people[Config.organizers] = organizers
    }
    
    static func getPeopleInstance() -> People {
        return sharedInstance
    }
    
    func addPerson(_ person: Person, category: String) {
        var array: [Person] = people[category] ?? []
        array.append(person)
        people[category] = array
    }
    
    func retrievePerson(category: String, index: Int) -> Person? {
        guard let array = people[category], array.count - 1 >= index else {
            return nil
        }
        return array[index]
    }
    
    func retrievePerson(category: String) -> [Person] {
        return people[category] ?? []
    }
    
}
