import UIKit

struct System {
    
    static var client = FirebaseClient()
    
    static var activeUser: User?
    
    static var mentors: [User] = {
        var users = [User]()
        client.getMentors(completion: { (mentors, error) in
            users = mentors
        })
        
        return users
    }()
    
    static func createSampleMentors() {
        let create = true
        
        if create {
            let image = UIImage(named: "Profile")
            let type = UserTypes(isParticipant: false, isSpeaker: false, isMentor: true, isOrganizer: false, isAdmin: false)
            let profile = Profile(type: type, team: -1, name: "Mr Tan Hwee Huat", username: "HweeHuat", image: image!, job: "Asset Manager",
                                  company: "UOB Pte. Ltd.", country: "Singapore",
                                  education: "National University of Singapore",
                                  skills: "Financial Planning", description: "Awesome guy")
            let email = "mentor100@mentor.com"
            let password = "Password123"
            let user = User(profile: profile, type: type, email: email)
            
            let mentor = Mentor(profile: profile, field: .business)
            mentor.addSlots(on: Date.date(from: "2017-07-21"))
            mentor.addSlots(on: Date.date(from: "2017-07-22"))
            mentor.addSlots(on: Date.date(from: "2017-07-23"))
            mentor.addSlots(on: Date.date(from: "2017-07-24"))
            
            user.setMentor(mentor: mentor)
            
            System.client.createNewUser(user, email: email, password: password, completion: {
                (error) in
            })
        }
    }

    static func updateActiveUser() {
        guard let user = activeUser else {
            return
        }
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: user)
        UserDefaults.standard.set(encodedData, forKey: Config.user)
    }
    
}
