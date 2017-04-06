//
//  Utility.swift
//  SWSG
//
//  Created by shixiyue on 13/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

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
    
    //TODO: Implement Check for Updates
    static func getProfileImg(uid: String, completion: @escaping (UIImage?) -> Void) {
        if System.profileImageCache.keys.contains(uid) {
            completion(System.profileImageCache[uid])
        } else {
            System.client.fetchProfileImage(for: uid, completion: { (image) in
                System.profileImageCache[uid] = image
                completion(image)
            })
        }
    }
    
    //TODO: Implement Check for Updates
    static func getChatIcon(id: String, completion: @escaping (UIImage?) -> Void) {
        if System.chatIconCache.keys.contains(id) {
            completion(System.chatIconCache[id])
        } else {
            System.client.fetchChannelIcon(for: id, completion: { (image) in
                System.chatIconCache[id] = image
                completion(image)
                
            })
        }
    }
    
    static func createPopUpWithTextField(title: String, message: String, btnText: String, placeholderText: String, existingText: String, viewController: UIViewController, completion: @escaping (String) -> Void) {
        //Creating a Alert Popup for Saving
        let createController = UIAlertController(title: title, message: message,
                                                 preferredStyle: UIAlertControllerStyle.alert)
        
        //Creates a Save Button for the Popup
        let action = UIAlertAction(title: btnText, style: .default) { _ -> Void in
            
            if let textField = createController.textFields?[0] {
                guard var text = textField.text else {
                    return
                }
                
                text = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                
                completion(text)
            }
        }
        createController.addAction(action)
        
        //Creates a Cancel Button for the Popup
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
        }
        createController.addAction(cancelAction)
        
        //Creates a Textfield to enter the Level Name in the Popup
        createController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = placeholderText
            
            if existingText.characters.count > 0 {
                textField.text = existingText
            }
            
            //Disable the Save Button by default
            action.isEnabled = false
            
            textField.textAlignment = .center
            
            guard let _ = viewController as? UITextFieldDelegate else {
                return
            }
            
            textField.delegate = viewController as? UITextFieldDelegate
            textField.returnKeyType = .done
            
            //Sets the Save Button to disabled if the textfield is empty
            NotificationCenter.default.addObserver(
                forName: NSNotification.Name.UITextFieldTextDidChange,
                object: textField, queue: OperationQueue.main) { _ in
                    guard var text = textField.text else {
                        return
                    }
                    text = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    
                    if text != "" {
                        action.isEnabled = true
                    } else {
                        action.isEnabled = false
                    }
            }
        })
        
        //Displays the Save Popup
        viewController.present(createController, animated: true, completion: nil)
    }
    
}
