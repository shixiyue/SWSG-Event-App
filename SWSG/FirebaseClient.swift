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
    typealias GetUserCallback = (User, FirebaseError?) -> Void
    typealias GetMentorsCallback = ([User], FirebaseError?) -> Void
    typealias CreateTeamCallback = (FirebaseError?) -> Void
    typealias CreateEventCallback = (FirebaseError?) -> Void
    typealias GetEventCallback = (Event, FirebaseError?) -> Void
    typealias GetEventByDayCallback = ([Event], FirebaseError?) -> Void
    
    private let usersRef = FIRDatabase.database().reference(withPath: "users")
    private let teamsRef = FIRDatabase.database().reference(withPath: "teams")
    private let eventsRef = FIRDatabase.database().reference(withPath: "events")
    
    public func createNewUser(_ user: User, email: String, password: String, completion: @escaping CreateUserCallback) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: {(firUser, err) in
            if err == nil {
                if let uid = firUser?.uid {
                    let userRef = self.usersRef.child(uid)
                    userRef.setValue(user.toDictionary() as Any)
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
    
    public func alreadySignedIn() -> Bool {
        if let _ = FIRAuth.auth()?.currentUser {
            return true
        } else {
            return false
        }
    }
    
    //TEMP SOLUTION
    public func signOut() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch {
            return
        }
    }
    
    public func getMentors(completion: @escaping GetMentorsCallback) {
        let mentorRef = usersRef.queryOrdered(byChild: "userType/isMentor").queryEqual(toValue: true)
        mentorRef.observeSingleEvent(of: .value, with: {(snapshot) in
            var mentors = [User]()
            for mentor in snapshot.children {
                guard let mentor = mentor as? FIRDataSnapshot, let user = User(snapshot: mentor) else {
                    continue
                }
                
                user.setUid(uid: mentor.key)
                mentors.append(user)
            }
            completion(mentors, nil)
        })
    }
    
    public func getCurrentUser(completion: @escaping GetUserCallback) {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        getUserWith(uid: uid, completion: completion)
    }

    public func getUserWith(uid: String, completion: @escaping GetUserCallback) {
        let userRef = usersRef.child(uid)
        // TODO: handle error
        userRef.observeSingleEvent(of: .value, with: {(snapshot) in
            let user = User(snapshot: snapshot)!
            user.setUid(uid: uid)
            completion(user, nil)
        })
    }
    
    public func updateUser(newUser: User) {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        let userRef = usersRef.child(uid)
        userRef.setValue(newUser.toDictionary() as Any)
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
    
    public func getMentorRef(for uid: String) -> FIRDatabaseReference {
        return databaseReference(for: "users/\(uid)")
    }
    
    private func databaseReference(for name: String) -> FIRDatabaseReference {
        return FIRDatabase.database().reference().child(name)
    }
}

