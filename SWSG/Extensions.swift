//
//  Extensions.swift
//  SWSG
//
//  Created by shixiyue on 13/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension NSCoder {
    func encodeUserTypes(_ type: UserTypes) {
        self.encode(type.isParticipant, forKey: Config.isParticipant)
        self.encode(type.isSpeaker, forKey: Config.isSpeaker)
        self.encode(type.isMentor, forKey: Config.isMentor)
        self.encode(type.isOrganizer, forKey: Config.isOrganizer)
        self.encode(type.isAdmin, forKey: Config.isAdmin)
    }
    
    func decodeUserTyes() -> UserTypes {
        let isParticipant = self.decodeBool(forKey: Config.isParticipant)
        let isSpeaker = self.decodeBool(forKey: Config.isSpeaker)
        let isMentor = self.decodeBool(forKey: Config.isMentor)
        let isOrganizer = self.decodeBool(forKey: Config.isOrganizer)
        let isAdmin = self.decodeBool(forKey: Config.isAdmin)
        return UserTypes(isParticipant: isParticipant, isSpeaker: isSpeaker, isMentor: isMentor, isOrganizer: isOrganizer, isAdmin: isAdmin)
    }
}
