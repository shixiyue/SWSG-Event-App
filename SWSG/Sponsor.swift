//
//  Sponsor.swift
//  SWSG
//
//  Created by Shi Xiyue on 11/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//
/*
import UIKit

class Sponsor {
    
    public private(set) var image: UIImage = Config.defaultSponsorImage
    public private(set) var name: String
    public private(set) var link: String
    
    private var imageURL: String?
    
    init(image: UIImage, name: String, link: String) {
        self.image = image
        self.name = name
        self.link = link
    }
    
    init?(snapshotValue: [String: String]) {
        guard let name = snapshotValue[Config.name] else {
            return nil
        }
        self.name = name
        guard let link = snapshotValue[Config.title] else {
            return nil
        }
        self.link = link
        if let imageURL = snapshotValue[Config.image] {
            self.imageURL = imageURL
        }
    }
    
    // TODO: Make a protocol
    func loadImage(completion: @escaping (Bool) -> Void) {
        guard let imageURL = imageURL else {
            completion(false)
            return
        }
        Utility.getImage(name: imageURL, completion: { (image) in
            self.imageURL = nil
            guard let image = image else {
                completion(false)
                return
            }
            self.image = image
            completion(true)
        })
    }
    
    func toDictionary() -> [String: String] {
        return [Config.name: name, Config.link: link]
    }
    
}

extension Sponsor: Equatable { }

func ==(lhs: Sponsor, rhs: Sponsor) -> Bool {
    return lhs.name == rhs.name
} */
