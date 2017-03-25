//
//  FirebaseError.swift
//  SWSG
//
//  Created by dinhvt on 25/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation

enum SignUpError: Error {
    case emailExisted
    case emailInvalid
    case wrongPassword
}

enum GetProfileError: Error {
    case userNotExist
}
