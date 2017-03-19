import UIKit

struct System {
    
    static var activeUser: User? {
        didSet {
            guard let user = activeUser else {
                return
            }
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: user)
            UserDefaults.standard.set(encodedData, forKey: Config.user)
        }
    }
    
    public static var mentors: [Mentor] {
        var mentors = [Mentor]()
        let image = UIImage(named: "Profile")
        let profile = Profile(name: "Mr Tan Hwee Huat", image: image!, job: "Asset Manager",
                              company: "UOB Pte. Ltd.", country: "Singapore",
                              education: "National University of Singapore",
                              skills: "Financial Planning", description: "Awesome guy")
        
        for _ in 0...4 {
            let mentor = Mentor(profile: profile, field: .business)
            mentor.addSlots(on: Date.date(from: "2017-07-21"))
            mentor.addSlots(on: Date.date(from: "2017-07-22"))
            mentor.addSlots(on: Date.date(from: "2017-07-23"))
            mentors.append(mentor)
        }
        
        return mentors
    }
}
