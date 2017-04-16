//
//  Person.swift
//  SWSG
//
//  Created by Shi Xiyue on 6/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//


/**
 Person is a class that represents a person in the Information System
 
 Specifications:
 - id: The ID of the Person as given by Firebase
 - name: Name of the Person
 - photo: Photo of the Person
 - title: Title of the Person
 - intro: Intro of the Person
 
 Representation Invariant:
 - The name of the Person cannnot be empty
 */
class Person {
    
    var id: String?
    public private(set) var photo: UIImage = Config.defaultPersonImage
    public private(set) var name: String
    public private(set) var title: String
    public private(set) var intro: String
    
    private var photoURL: String?
    
    init(photo: UIImage, name: String, title: String, intro: String) {
        self.photo = photo
        self.name = name
        self.title = title
        self.intro = intro
        _checkRep()
    }
    
    init?(snapshotValue: [String: String]) {
        guard let id = snapshotValue[Config.id] else {
            return nil
        }
        self.id = id
        guard let name = snapshotValue[Config.name] else {
            return nil
        }
        self.name = name
        guard let title = snapshotValue[Config.title] else {
            return nil
        }
        self.title = title
        guard let intro = snapshotValue[Config.intro] else {
            return nil
        }
        self.intro = intro
        if let photoURL = snapshotValue[Config.photo] {
            self.photoURL = photoURL
        }
        _checkRep()
    }
    
    func loadImage(completion: @escaping (Bool) -> Void) {
        _checkRep()
        guard let photoURL = photoURL else {
            completion(false)
            return
        }
        Utility.getImage(name: photoURL, completion: { (photo) in
            self.photoURL = nil
            guard let photo = photo else {
                completion(false)
                self._checkRep()
                return
            }
            self.photo = photo
            completion(true)
            self._checkRep()
        })
    }
    
    func toDictionary() -> [String: String] {
        var dict = [Config.name: name, Config.title: title, Config.intro: intro]
        if let id = id {
            dict[Config.id] = id
        }
        return dict
    }
    
    private func _checkRep() {
        #if DEBUG
        assert(!name.isEmpty)
        #endif
    }
    
}

extension Person: Equatable { }

func ==(lhs: Person, rhs: Person) -> Bool {
    
    if let lhsId = lhs.id, let rhsId = rhs.id {
        return lhsId == rhsId
    }
    return lhs.name == rhs.name
        && lhs.title == rhs.title
        && lhs.intro == rhs.intro
        && lhs.photo == rhs.photo
}
