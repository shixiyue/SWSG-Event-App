//
//  AppDelegate.swift
//  SWSG
//
//  Created by Jeremy Jee on 9/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FacebookCore
import Google
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        setNavigationBar()
        setUpFirebase()
        setUpGoogleLogin()
        checkLogin()
        return true
    }
    
    /// Sets the color of navigation  bar.
    private func setNavigationBar() {
        UINavigationBar.appearance().barTintColor = Config.themeColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UINavigationBar.appearance().tintColor = UIColor.white
    }
    
    private func setUpFirebase() {
        FIRApp.configure()
    }
    
    private func setUpGoogleLogin() {
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
    }
    
    //TODO: Automatic Login with Firebase
    private func checkLogin() {
        if System.client.alreadySignedIn() {
            showLaunchScreen()
            System.client.getCurrentUser(completion: { (user, userError) in
                if let user = user {
                    System.activeUser = user
                    self.showHomeScreen()
                } else {
                    self.showLogInSignUpScreen()
                }
            })
        } else {
            showLogInSignUpScreen()
            return
        }
    }
    
    /// Shows launchScreen while waiting for firebase screen if the user hasn't loged in.
    private func showLaunchScreen() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: Config.launchScreen, bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: Config.initialScreen)
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    
    /// Shows HomeScreen fter Firebase loads
    private func showHomeScreen() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: Config.main, bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: Config.navigationController)
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    
    /// Shows logInSignUp screen if the user hasn't loged in.
    private func showLogInSignUpScreen() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: Config.logInSignUp, bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: Config.initialScreen)
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
    
    public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        guard let scheme = url.scheme else {
            return false
        }
        
        if scheme.hasPrefix("com.googleusercontent.apps.") {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
        } else if scheme.hasPrefix("fb\(SDKSettings.appId)") {
            let handled = SDKApplicationDelegate.shared.application(app, open: url, options: options)
            
            return handled
        }
        
        return false
    }
}

