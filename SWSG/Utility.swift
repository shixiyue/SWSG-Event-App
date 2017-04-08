//
//  Utility.swift
//  SWSG
//
//  Created by shixiyue on 13/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import EventKit

struct Utility {
    
    static func roundUIImageView(for image: UIImageView) -> UIImageView {
        image.layer.cornerRadius = image.frame.size.width / 2
        image.clipsToBounds = true
        
        return image
    }
    
    static let countries = NSLocale.isoCountryCodes.map { (code: String) -> String in
        let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
        let currentLocaleID = NSLocale.current.identifier
        return NSLocale(localeIdentifier: currentLocaleID).displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
    }
    
    static let defaultCountryIndex = countries.index(of: Config.defaultCountry) ?? 0
    
    static func isValidEmail(testStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    static func isValidPassword(testStr: String) -> Bool {
        return testStr.characters.count >= Config.passwordMinLength
    }
    
    /// Jumps to another storyboard
    static func showStoryboard(storyboard: String, destinationViewController: String, currentViewController: UIViewController) {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: destinationViewController) as UIViewController

        currentViewController.present(controller, animated: false, completion: nil)
    }
    
    static func showStoryboardByNavigation(storyboard: String, destinationViewController: String, currentViewController: UIViewController) {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: destinationViewController) as UIViewController

        currentViewController.present(controller, animated: true, completion: nil)

        controller.navigationItem.hidesBackButton = currentViewController.navigationItem.hidesBackButton
    controller.navigationController?.setNavigationBarHidden(controller.navigationItem.hidesBackButton, animated: false)
        //currentViewController.navigationController?.pushViewController(controller, animated: true)
    }
    
    static func onBackButtonClick(tableViewController: UITableViewController) {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        tableViewController.view.window!.layer.add(transition, forKey: nil)
        tableViewController.dismiss(animated: false, completion: nil)
    }
    
    static func onBackButtonClick(tableViewController: UIViewController) {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        tableViewController.view.window!.layer.add(transition, forKey: nil)
        tableViewController.dismiss(animated: false, completion: nil)
    }
    
    static func logOutUser(currentViewController: UIViewController) {
        System.activeUser = nil
        showStoryboard(storyboard: Config.logInSignUp, destinationViewController: Config.initialScreen, currentViewController: currentViewController)
        System.client.signOut()
    }
    
    static func logInUser(user: User, currentViewController: UIViewController) {
        System.activeUser = user
        showStoryboard(storyboard: Config.main, destinationViewController: Config.navigationController, currentViewController: currentViewController)
    }
    
    static func getFailAlertController(message: String) -> UIAlertController {
        let alertController = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        return alertController
    }
    
    static func getSuccessAlertController() -> UIAlertController {
        let alertController = UIAlertController(title: "Success", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        return alertController
    }

    static func getDestinationStoryboard(from navController: UIViewController) -> UIViewController? {
        guard let navController = navController as? UINavigationController else {
            return nil
        }
        
        return navController.viewControllers[0]
    }
    
    static var fbDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
    
        formatter.dateFormat = "d-MM-yyyy"
    
        return formatter
    }
    
    static var fbDateTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        
        formatter.dateFormat = "d-MM-yyyy-HH:mm"
        
        return formatter
    }
    
    static func displayDismissivePopup(title: String, message: String,
                                       viewController: UIViewController,
                                       completion: @escaping () -> Void) {
        let dismissController = UIAlertController(title: title, message: message,
                                                  preferredStyle: UIAlertControllerStyle.alert)
        
        //Add an Action to Confirm quitting with the Destructive Style
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default) { _ in
            completion()
        }
        dismissController.addAction(dismissAction)
        
        //Present the Popup
        viewController.present(dismissController, animated: true, completion: nil)
    }
    
    static func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate 
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let e as NSError {
                    completion?(false, e)
                    return
                }
                completion?(true, nil)
            } else {
                completion?(false, error as NSError?)
            }
        })
    }
    static func strtok(string: String, delimiter: String) -> [Int] {
        let values = string.components(separatedBy: delimiter).flatMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        return values
    }
    
}
