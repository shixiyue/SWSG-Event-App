//
//  FirebaseError.swift
//  SWSG
//
//  Created by dinhvt on 25/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation

// refer to https://firebase.google.com/docs/auth/ios/errors

enum FirebaseError: Error {
    case networkError
    case userNotFound
    case userTokenExpired
    
    case emailAlreadyInUse
    case invalidEmail
    case weakPassword
    
    case userDisabled
    case wrongPassword
    
    case otherError(errorCode: Int)
}

