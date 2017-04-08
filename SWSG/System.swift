import UIKit

struct System {
    
    static var client = FirebaseClient()
    
    static var activeUser: User?
    
    static var profileImageCache = [String: (image: UIImage, url: String)]()
    static var chatIconCache = [String: (image: UIImage, url: String)]()
    
    static var mentors: [User] = {
        var users = [User]()
        client.getMentors(completion: { (mentors, error) in
            users += mentors
        })
        print("\(users.count)")
        return users
    }()
    
    static func createSampleMentors() {
        let create = true
        
        if create && System.client.alreadySignedIn() {
            let image = UIImage(named: "Profile")
            let type = UserTypes(isParticipant: false, isSpeaker: false, isMentor: true, isOrganizer: false, isAdmin: false)
            let profile = Profile(name: "Mr Lim Lay Buat", username: "LimLay", image: image!, job: "Asset Manager",
                                  company: "DBS Pte. Ltd.", country: "Singapore",
                                  education: "Nanyang Technological University",
                                  skills: "Financial Planning", description: "SuperAwesome guy")
            let email = "mentor100000@mentor.com"
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
   
}
