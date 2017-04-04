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
    typealias CreateTeamCallback = (FirebaseError?) -> Void
    typealias CreateEventCallback = (FirebaseError?) -> Void
    typealias GetEventCallback = (Event, FirebaseError?) -> Void
    typealias GetEventByDayCallback = ([Event], FirebaseError?) -> Void
    
    private let profilesRef = FIRDatabase.database().reference(withPath: "profiles")
    private let teamsRef = FIRDatabase.database().reference(withPath: "teams")
    private let eventsRef = FIRDatabase.database().reference(withPath: "events")
    
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
    
    public func getProfileOfCurrentUser(completion: @escaping GetProfileCallback) {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        getProfileOfUserWith(uid: uid, completion: completion)
    }

    public func getProfileOfUserWith(uid: String, completion: @escaping GetProfileCallback) {
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
    
    public func createEvent(_ event: Event, completion: @escaping CreateEventCallback) {
        let dayString = event.getDayString()
        let eventId = UUID().uuidString
        let eventRef = eventsRef.child(dayString).child(eventId)
        eventRef.setValue(event.toAnyObject(), withCompletionBlock: { (err, _) in
            completion(self.checkError(err))
        })
    }
    
    public func getEventWithId(_ eventId: String, completion: @escaping GetEventCallback) {
        // TODO
    }
    
    public func getEventByDay(_ day: Date, completion: @escaping GetEventByDayCallback) {
        let dayString = day.string(format: Config.dateTimeFormatDayString)
        let dayRef = eventsRef.child(dayString)
        dayRef.observeSingleEvent(of: .value, with: {(snapshot) in
            var events = [Event]()
            for event in snapshot.children {
                events.append(Event(snapshot: event as! FIRDataSnapshot)!)
            }
            completion(events, nil)
        })
    }
    
    func getUid() -> String {
        return FIRAuth.auth()?.currentUser?.uid ?? ""
    }
    
    private func checkError(_ err: Error?) -> FirebaseError? {
        guard let nsError = err as NSError? else {
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
    
    public func getChannelsRef() -> FIRDatabaseReference {
        return databaseReference(for: Config.channelsRef)
    }
    
    private func databaseReference(for name: String) -> FIRDatabaseReference {
        return FIRDatabase.database().reference().child(name)
    }
}

