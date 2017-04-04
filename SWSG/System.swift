import UIKit

struct System {
    
    static var client = FirebaseClient()
    
    static var activeUser: User? {
        didSet {
            guard let user = activeUser else {
                UserDefaults.standard.removeObject(forKey: Config.user)
                return
            }
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: user)
            UserDefaults.standard.set(encodedData, forKey: Config.user)
        }
    }
    
    public static var mentors: [Mentor] {
        var mentors = [Mentor]()
        let image = UIImage(named: "Profile")
        let type = UserTypes(isParticipant: false, isSpeaker: false, isMentor: true, isOrganizer: false, isAdmin: false)
        let profile = Profile(type: type, team: -1, name: "Mr Tan Hwee Huat", username: "HweeHuat", image: image!, job: "Asset Manager",
                              company: "UOB Pte. Ltd.", country: "Singapore",
                              education: "National University of Singapore",
                              skills: "Financial Planning", description: "Awesome guy")
        
        for _ in 0...4 {
            let mentor = Mentor(profile: profile, field: .business)
            mentor.addSlots(on: Date.date(from: "2017-07-21"))
            mentor.addSlots(on: Date.date(from: "2017-07-22"))
            mentor.addSlots(on: Date.date(from: "2017-07-23"))
            mentor.addSlots(on: Date.date(from: "2017-07-24"))
            mentors.append(mentor)
        }
        
        return mentors
    }

    static func updateActiveUser() {
        guard let user = activeUser else {
            return
        }
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: user)
        UserDefaults.standard.set(encodedData, forKey: Config.user)
    }
    
}
