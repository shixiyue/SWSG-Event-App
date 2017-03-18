import Foundation

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
    
}
