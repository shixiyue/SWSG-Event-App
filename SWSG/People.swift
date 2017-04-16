//
//  Person.swift
//  SWSG
//
//  Created by Shi Xiyue on 6/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Firebase

/**
 People is a collection of all person object which represents a local cache of all person
 in Information System.
 It follows singleton pattern.
 
 Specifications:
 - people: A mutable [String: [Person]] object which represents all people
 */
class People {
    
    private var people = [String: [Person]]()
    private static var sharedInstance = People()
    
    private init() { }
    
    static func getPeopleInstance() -> People {
        return sharedInstance
    }
    
    func add(category: String, snapshot: FIRDataSnapshot) {
        guard let snapshotValue = snapshot.value as? [String: String] else {
            return
        }
        guard let person = Person(snapshotValue: snapshotValue) else {
            return
        }
        var peopleInSameCategory = people[category] ?? []
        guard peopleInSameCategory.index(of: person) == nil else {
            return
        }
        peopleInSameCategory.append(person)
        people[category] = peopleInSameCategory.sorted(by: {$0.name < $1.name})
    }
    
    func retrievePerson(category: String) -> [Person] {
        return people[category] ?? []
    }
    
}
