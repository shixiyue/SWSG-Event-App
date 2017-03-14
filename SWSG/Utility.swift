//
//  Utility.swift
//  SWSG
//
//  Created by shixiyue on 13/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

struct Utility {
    
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
    
    static func logOutUser(currentViewController: UIViewController) {
        UserDefaults.standard.removeObject(forKey: Config.user)
        showLogInSignUpScreen(currentViewController: currentViewController)
    }
    
    private static func showLogInSignUpScreen(currentViewController: UIViewController) {
        let storyboard = UIStoryboard(name: Config.logInSignUp, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: Config.initialScreen) as UIViewController
        currentViewController.present(controller, animated: true, completion: nil)
    }
    
    static func logInUser(user: User, currentViewController: UIViewController) {
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: user)
        UserDefaults.standard.set(encodedData, forKey: Config.user)
        showMainMenuScreen(currentViewController: currentViewController)
    }
    
    private static func showMainMenuScreen(currentViewController: UIViewController) {
        let storyboard = UIStoryboard(name: Config.main, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: Config.mainMenuScreen) as UIViewController
        currentViewController.present(controller, animated: true, completion: nil)
    }
    
    static func getFailAlertController(message: String) -> UIAlertController {
        let alertController = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        return alertController
    }
    
}
