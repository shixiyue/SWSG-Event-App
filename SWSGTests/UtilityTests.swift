//
//  SWSGTests.swift
//  SWSGTests
//
//  Created by Shi Xiyue on 18/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import XCTest
@testable import SWSG

class UtilityTests: XCTestCase {
    
    func testEmailValidation_validEmail_success() {
        let email1 = "swsg_app@gmail.com"
        let email2 = "2017@3217.org"
        let email3 = "a@a.com"
        
        XCTAssertTrue(Utility.isValidEmail(testStr: email1))
        XCTAssertTrue(Utility.isValidEmail(testStr: email2))
        XCTAssertTrue(Utility.isValidEmail(testStr: email3))
    }
    
    func testEmailValidation_invalidAt_fail() {
        let email1 = "swsggmail.com"
        let email2 = "swsg@gmail@gmail.com"
        let email3 = ""
        
        XCTAssertFalse(Utility.isValidEmail(testStr: email1))
        XCTAssertFalse(Utility.isValidEmail(testStr: email2))
        XCTAssertFalse(Utility.isValidEmail(testStr: email3))
    }
    
    func testEmailValidation_invalidLocalPart_fail() {
        let email = "@gmail.com"
        XCTAssertFalse(Utility.isValidEmail(testStr: email))
    }
    
    func testEmailValidation_invalidDomain_fail() {
        let email1 = "swsg@"
        let email2 = "swsg@gmail"
        
        XCTAssertFalse(Utility.isValidEmail(testStr: email1))
        XCTAssertFalse(Utility.isValidEmail(testStr: email2))
    }
    
    func testPasswordValidation_validPassword_success() {
        let password1 = "123456"
        let password2 = "helloworld"
        
        XCTAssertTrue(Utility.isValidPassword(testStr: password1))
        XCTAssertTrue(Utility.isValidPassword(testStr: password2))
    }
    
    func testPasswordValidation_invalidPassword_fail() {
        let password1 = ""
        let password2 = "12345"
        
        XCTAssertFalse(Utility.isValidPassword(testStr: password1))
        XCTAssertFalse(Utility.isValidPassword(testStr: password2))
    }
    
}
