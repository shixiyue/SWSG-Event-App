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
    typealias UserAuthCallback = (FirebaseError?) -> Void
    typealias GetUserCallback = (User?, FirebaseError?) -> Void
    typealias GetMentorsCallback = ([User], FirebaseError?) -> Void
    typealias CreateTeamCallback = (FirebaseError?) -> Void
    typealias CreateEventCallback = (FirebaseError?) -> Void
    typealias GetMessageCallback = (Message, FirebaseError?) -> Void
    typealias GetEventCallback = (Event, FirebaseError?) -> Void
    typealias GetEventByDayCallback = ([Event], FirebaseError?) -> Void
    typealias ImageURLCallback = (String?, FirebaseError?) -> Void
    typealias ImageCallback = (UIImage?) -> Void
    
    private let usersRef = FIRDatabase.database().reference(withPath: "users")
    private let teamsRef = FIRDatabase.database().reference(withPath: "teams")
    private let eventsRef = FIRDatabase.database().reference(withPath: "events")
    private let storageRef = FIRStorage.storage().reference(forURL: Config.appURL)
    
    public func createNewUser(_ user: User, email: String, password: String, completion: @escaping CreateUserCallback) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: {(firUser, err) in
            if err == nil {
                if let uid = firUser?.uid {
                    let userRef = self.usersRef.child(uid)
                    userRef.setValue(user.toDictionary() as Any)
                    self.saveImage(image: user.profile.image, completion: { (photoURL, error) in
                            userRef.child(Config.profile).child(Config.image).setValue(photoURL)
                    })
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
    
    func reauthenticateUser(email: String, password: String, completion: @escaping UserAuthCallback) {
        let user = FIRAuth.auth()?.currentUser
        let credential = FIREmailPasswordAuthProvider.credential(withEmail: email, password: password)
        
        user?.reauthenticate(with: credential) { error in
            completion(self.checkError(error))
        }
    }
    
    func changePassword(newPassword: String, completion: @escaping UserAuthCallback) {
        FIRAuth.auth()?.currentUser?.updatePassword(newPassword) { error in
            completion(self.checkError(error))
        }
    }
    
    public func getMentors(completion: @escaping GetMentorsCallback) {
        let mentorRef = usersRef.queryOrdered(byChild: "\(Config.userType)/\(Config.isMentor)")
                                .queryEqual(toValue: true)
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
            guard let user = User(snapshot: snapshot) else {
                completion(nil, nil)
                return
            }
            user.setUid(uid: uid)
            completion(user, nil)
        })
    }
    
    public func getUserWith(username: String, completion: @escaping GetUserCallback) {
        let userRef = usersRef
            .queryOrdered(byChild: "\(Config.profile)/\(Config.username)").queryEqual(toValue: username)
        userRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.children.allObjects.count == 0 {
                completion(nil, nil)
            } else {
                var userAcct: User?
                for userSnapshot in snapshot.children {
                    guard let userSnapshot = userSnapshot as? FIRDataSnapshot,
                        let user = User(snapshot: userSnapshot) else {
                        continue
                    }
                    
                    user.setUid(uid: userSnapshot.key)
                    userAcct = user
                }
                
                completion(userAcct, nil)
            }
        })
    }
    
    public func updateUser(newUser: User) {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        let userRef = usersRef.child(uid)
        userRef.setValue(newUser.toDictionary() as Any)
        
        self.saveImage(image: newUser.profile.image, completion: { (photoURL, error) in
            userRef.child(Config.profile).child(Config.image).setValue(photoURL)
        })
    }
    
    public func createEvent(_ event: Event, completion: @escaping CreateEventCallback) {
        let dayString = event.getDayString()
        let eventId = UUID().uuidString
        let eventRef = eventsRef.child(dayString).child(eventId)
     //   eventRef.setValue(event.toAnyObject(), withCompletionBlock: { (err, _) in
       //     completion(self.checkError(err))
       // })
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
    
    public func createChannel(for channel: Channel) {
        let channelsRef = getChannelsRef()
        let channelRef = channelsRef.childByAutoId()
        
        if let name = channel.name {
            channelRef.child(Config.name).setValue(name)
        }
        
        channelRef.child(Config.channelType).setValue(channel.type.rawValue)
        channelRef.child(Config.members).setValue(channel.members)
        
        guard let icon = channel.icon else {
            return
        }
        
        saveImage(image: icon, completion: { (imageURL, firError) in
            guard firError == nil else {
                return
            }
            channelRef.child(Config.image).setValue(imageURL)
            
        })
    }
    
    public func deleteChannel(for channel: Channel) {
        guard let id = channel.id else {
            return
        }
        
        let channelsRef = getChannelsRef()
        let channelRef = channelsRef.child(id)
        channelRef.removeValue { (error, ref) in
        }
    }
    
    public func saveImage(image: UIImage, completion: @escaping ImageURLCallback) {
        let imageData = image.jpeg(.low)
        let imagePath = FIRAuth.auth()!.currentUser!.uid + "/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
        
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        self.storageRef.child(imagePath).put(imageData!, metadata: metadata) { (metadata, error) in
            guard let metadata = metadata, let path = metadata.path else {
                completion(nil, self.checkError(error))
                return
            }
            
            completion("\(Config.appURL)/\(path)", self.checkError(error))
        }
    }
    
    public func fetchImageDataAtURL(_ imageURL: String, completion: @escaping ImageCallback) {
        let storageRef = FIRStorage.storage().reference(forURL: imageURL)
        
        storageRef.data(withMaxSize: INT64_MAX){ (data, error) in
            if let error = error {
                print("Error downloading image data: \(error)")
                return
            }
            
            storageRef.metadata(completion: { (metadata, metadataErr) in
                guard let data = data else {
                    if let err = metadataErr {
                        print("Error downloading metadata: \(err)")
                    }
                    return
                }
                
                completion(UIImage.init(data: data))
            })
        }
    }
    
    public func fetchProfileImage(for uid: String, completion: @escaping ImageCallback) {
        fetchImage(for: usersRef.child(uid).child(Config.profile), completion: { (image) in
            completion(image)
        })
    }
    
    public func fetchChannelIcon(for id: String, completion: @escaping ImageCallback) {
        fetchImage(for: getChannelsRef().child(id), completion: { (image) in
            completion(image)
        })
    }
    
    private func fetchImage(for ref: FIRDatabaseReference, completion: @escaping ImageCallback) {
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard snapshot.hasChild(Config.image) else {
                completion(nil)
                return
            }
            
            let data = snapshot.childSnapshot(forPath: Config.image)
            guard let imageURL = data.value as? String else {
                completion(nil)
                return
            }
            
            self.fetchImageDataAtURL(imageURL, completion: { (image)  in
                completion(image)
            })
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
    
    public func getLatestMessageQuery(for channel: String) -> FIRDatabaseQuery {
        return getChannelsRef().child(channel).child(Config.messages).queryLimited(toLast: 1)
    }
    
    public func getUserRef(for uid: String) -> FIRDatabaseReference {
        return databaseReference(for: Config.users).child(uid)
    }
    
    public func getMentorsRef() -> FIRDatabaseQuery {
        return usersRef.queryOrdered(byChild: "userType/isMentor").queryEqual(toValue: true)
    }
    
    private func databaseReference(for name: String) -> FIRDatabaseReference {
        return FIRDatabase.database().reference().child(name)
    }
}

