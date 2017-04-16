//
//  AuthType.swift
//  SWSG
//
//  Created by Jeremy Jee on 9/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation

/**
 AuthType is an enum representing the different possible Authentication Providers.
 The raw Value string is what Firebase identifies Auth Providers as.
 */
enum AuthType: String {
    case email = "password"
    case facebook = "facebook.com"
    case google = "google.com"
}
