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
    
    public func getChannelsRef() -> FIRDatabaseReference {
        return databaseReference(for: Config.channelsRef)
    }
    
    private func databaseReference(for name: String) -> FIRDatabaseReference {
        return FIRDatabase.database().reference().child(name)
    }
    
    
    private func getProfile(for uid: String) -> Profile? {
        let usersRef = databaseReference(for: "profiles")
        _ = usersRef.queryEqual(toValue: uid).observe(.value, with: {
            (snapshot) -> Void in
            return Profile(snapshot: snapshot)
        })
        
        return nil
    }
    /*
    private func deserializeProfile(for ref: FIRDatabaseReference) -> Profile {
        let company = ref.value(forKey: "company") as! String
        let country = ref.value(forKey: "country") as! String
        let desc = ref.value(forKey: "desc") as! String
        let education = ref.value(forKey: "education") as! String
        let job = ref.value(forKey: "job") as! String
        let name = ref.value(forKey: "name") as! String
        let skills = ref.value(forKey: "skills") as! String
        let team = ref.value(forKey: "team") as! Int
        
        let userTypesRef = ref.child("userType")
        let isAdmin = userTypesRef.value(forKey: "isAdmin") as! Bool
        let isMentor = userTypesRef.value(forKey: "isMentor") as! Bool
        let isOrganizer = userTypesRef.value(forKey: "isOrganizer") as! Bool
        let isParticipant = userTypesRef.value(forKey: "isParticipant") as! Bool
        let isSpeaker = userTypesRef.value(forKey: "isSpeaker") as! Bool
        let userType = UserTypes(isParticipant: isParticipant, isSpeaker: isSpeaker,
                                 isMentor: isMentor, isOrganizer: isOrganizer, isAdmin: isAdmin)
        
        return Profile(type: <#T##UserTypes#>, team: <#T##Int#>, name: <#T##String#>, image: <#T##UIImage#>, job: <#T##String#>, company: <#T##String#>, country: <#T##String#>, education: <#T##String#>, skills: <#T##String#>, description: <#T##String#>)
        
    }*/
    
}

