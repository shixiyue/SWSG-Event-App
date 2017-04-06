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
    
    /// The corresponding error message for the firebase error.
    var errorMessage: String {
        switch self {
        case .networkError:
            return "There was a network error.\n Please try again later."
        case .userNotFound:
            return "The email does not match any account."
        case .userTokenExpired:
            return "Sorry, you signed in too long ago.\n Please log out and log in again."
        case .emailAlreadyInUse:
            return "Email already taken.\n Please try again using another email."
        case .invalidEmail:
            return "Please enter a valid email address."
        case .weakPassword:
            return "Password must be greater than 6 characters."
        case .userDisabled:
            return "The account is disabled."
        case .wrongPassword:
            return "The email and password do not match."
        default:
            return "There was a problem.\n Please try again later."
        }
    }
}

