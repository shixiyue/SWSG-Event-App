import UIKit

struct System {
    
    static var client = FirebaseClient()
    
    static var activeUser: User?
    
    static var profileImageCache = [String: (image: UIImage, url: String)]()
    static var chatIconCache = [String: (image: UIImage, url: String)]()
    static var eventIconCache = [String: (image: UIImage, url: String)]()
    static var imageCache = [String: UIImage]()
    
    static var mentors: [User] = {
        var users = [User]()
        client.getMentors(completion: { (mentors, error) in
            users += mentors
        })
        return users
    }()
   
}
