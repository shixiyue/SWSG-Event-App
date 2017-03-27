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
    
    typealias CreateUserCallback = (FirebaseError?) -> Void
    typealias GetProfileCallback = (Profile, FirebaseError?) -> Void
    
    public func createNewUserWithProfile(_ profile: Profile, email: String, password: String, completion: @escaping CreateUserCallback) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: {(user, err) in
            if err == nil {
                let ref = FIRDatabase.database().reference(withPath: "profiles")
                if let uid = user?.uid {
                    let userRef = ref.child(uid)
                    userRef.setValue(profile.toDictionary() as Any)
                }

            }
            completion(self.checkError(err))
        })
        
    }
    
    public func getProfile(completion: GetProfileCallback) {
        
    }
    
    private func checkError(_ err: Error?) -> FirebaseError? {
        guard let nsError = err as? NSError else {
            return nil
        }
        guard let errorCode = FIRAuthErrorCode(rawValue: nsError.code) else {
            return nil
        }

        switch errorCode {
        case .errorCodeNetworkError:
            return FirebaseError.networkError
        case .errorCodeUserNotFound:
            return FirebaseError.userNotFound
        case .errorCodeUserTokenExpired:
            return FirebaseError.userTokenExpired
        case .errorCodeEmailAlreadyInUse:
            return FirebaseError.emailAlreadyInUse
        case .errorCodeInvalidEmail:
            return FirebaseError.invalidEmail
        case .errorCodeWeakPassword:
            return FirebaseError.weakPassword
        case .errorCodeUserDisabled:
            return FirebaseError.userDisabled
        case .errorCodeWrongPassword:
            return FirebaseError.wrongPassword
        default:
            return FirebaseError.otherError(errorCode: errorCode.rawValue)
        }
        
    }
    
    public func signUp(email: String, password: String) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: nil)
    }
    
    public func createUser(email: String, password: String) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: nil)
    }
    
    public func signIn(email: String, password: String) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password)
    }
    
}

