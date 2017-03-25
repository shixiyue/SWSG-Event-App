//
//  FirebaseClient.swift
//  SWSG
//
//  Created by dinhvt on 25/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import Foundation
import Firebase

class FirebaseClient {
    
    public static func createNewUser(email: String, password: String) {
        let ref = FIRDatabase.database().reference(withPath: "users")
        //let userRef = ref.child(email)
        print("bla", ref.key)
        let userRef = ref.child("thang")
        userRef.setValue(User1(email: email, password: password).toAnyObject())
    }
    
    public static func signUp(email: String, password: String) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: nil)
    }
    
    public static func signIn(email: String, password: String) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password)
    }
    
}
struct User1 {
    let email: String
    let password: String
    
    func toAnyObject() -> Any {
        return [
            "email": email,
            "password": password
        ]
    }
}

