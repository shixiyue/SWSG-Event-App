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
    typealias SignInCallback = (FirebaseError?) -> Void
    typealias GetProfileCallback = (Profile, FirebaseError?) -> Void
    
    private let profilesRef = FIRDatabase.database().reference(withPath: "profiles")
    
    public func createNewUserWithProfile(_ profile: Profile, email: String, password: String, completion: @escaping CreateUserCallback) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: {(user, err) in
            if err == nil {
                if let uid = user?.uid {
                    let userRef = self.profilesRef.child(uid)
                    userRef.setValue(profile.toDictionary() as Any)
                }
            }
            completion(self.checkError(err))
        })
        
    }
    
    public func signIn(email: String, password: String, completion: @escaping SignInCallback) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: {(user, err) in
            completion(self.checkError(err))
        })
    }
    
    public func getProfile(completion: @escaping GetProfileCallback) {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        let userRef = profilesRef.child(uid)
        // TODO: handle error
        userRef.observeSingleEvent(of: .value, with: {(snapshot) in
            completion(Profile(snapshot: snapshot)!, nil)

        })
    }
    
    public func updateProfile(newProfile: Profile) {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        let userRef = profilesRef.child(uid)
        userRef.setValue(newProfile.toDictionary() as Any)
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
    
}

