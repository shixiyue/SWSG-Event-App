//
//  BaseViewController.swift
//  AKSwiftSlideMenu
//  From https://github.com/ashishkakkad8/AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//
import UIKit

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int)
}

class BaseViewController: UIViewController, SlideMenuDelegate {
    
    var menuYOffset: CGFloat {
        if let navigationBarHeight = navigationController?.navigationBar.frame.size.height {
            return navigationBarHeight
        } else {
            return 0
        }
    }
    
    private var btnShowMenu: UIButton!
    private var tapGesture: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideMenu))
        tapGesture.isEnabled = false
        view.addGestureRecognizer(tapGesture)
    }
    
    func slideMenuItemSelectedAtIndex(_ index: Int) {
        guard let item = MenuItems.MenuOrder(rawValue: index), let type = System.activeUser?.type else {
            return
        }
        switch(item){
        case .home:
            self.open(viewController: Config.homeViewController, from: Config.mainStoryboard)
        case .information:
            self.open(viewController: Config.informationViewController,
                      from: Config.informationStoryboard)
        case .schedule:
            self.open(viewController: Config.eventViewController, from: Config.eventStoryboard)
        case .mentors:
            if type.isMentor {
                self.open(viewController: Config.mentorAdminViewController, from: Config.mentorStoryboard)
            } else {
                self.open(viewController: Config.mentorViewController, from: Config.mentorStoryboard)
            }
        case .teams:
            self.open(viewController: Config.teamRegistrationViewController, from: Config.teamStoryboard)
        case .chat:
            self.open(viewController: Config.chatViewController, from: Config.chatStoryboard)
        case .ideas:
            self.open(viewController: Config.ideasViewController, from: Config.ideasStoryboard)
        case .people:
            self.open(viewController: Config.profileListViewController, from: Config.profileStoryboard)
        case .registration:
            if type.isOrganizer {
                self.open(viewController: Config.registrationListViewController, from: Config.registrationStoryboard)
            } else {
                self.open(viewController: Config.participantRegistrationViewController, from: Config.registrationStoryboard)
            }
        case .logout:
            Utility.logOutUser(currentViewController: self)
        }
    }
    
    func open(viewController: String, from storyboard: String){
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let destViewController : UIViewController = storyboard.instantiateViewController(withIdentifier: viewController)
        
        let topViewController : UIViewController = self.navigationController!.topViewController!
        
        if (topViewController.restorationIdentifier! == destViewController.restorationIdentifier!){
            print("Same VC")
            hideMenu()
        } else {
            self.navigationController!.pushViewController(destViewController, animated: true)
        }
    }
    
    func addSlideMenuButton(){
        btnShowMenu = UIButton(type: UIButtonType.system)
        btnShowMenu.setImage(self.defaultMenuImage(), for: UIControlState())
        btnShowMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnShowMenu.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        self.navigationItem.leftBarButtonItem = customBarItem;
    }
    
    func defaultMenuImage() -> UIImage {
        var defaultMenuImage = UIImage()
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 30, height: 22), false, 0.0)
        
        UIColor.black.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 3, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 10, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 17, width: 30, height: 1)).fill()
        
        UIColor.white.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 4, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 11,  width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 18, width: 30, height: 1)).fill()
        
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return defaultMenuImage;
    }
    
    func onSlideMenuButtonPressed(_ sender : UIButton){
        if (sender.tag == 10)
        {
            // To Hide Menu If it already there
            hideMenu()
            return
        }
        
        sender.isEnabled = false
        sender.tag = 10
        
        tapGesture.isEnabled = true
        self.view.endEditing(true)
        
        let storyboard = UIStoryboard(name: "Menu", bundle: nil)
        let menuVC : MenuViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuVC.btnMenu = sender
        menuVC.delegate = self
        self.view.addSubview(menuVC.view)
        self.addChildViewController(menuVC)
        menuVC.view.layoutIfNeeded()
        
        let heightOffset = navigationController?.navigationBar.frame.size.height ?? 0
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: menuYOffset, width: UIScreen.main.bounds.size.width / 2, height: UIScreen.main.bounds.size.height - heightOffset);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: self.menuYOffset, width: UIScreen.main.bounds.size.width / 2, height: UIScreen.main.bounds.size.height - heightOffset);
            sender.isEnabled = true
        }, completion:nil)
    }
    
    func hideMenu() {
        btnShowMenu.tag = 0
        tapGesture.isEnabled = false
        
        let viewMenuBack : UIView = view.subviews.last!
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            var frameMenu : CGRect = viewMenuBack.frame
            frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
            viewMenuBack.frame = frameMenu
            viewMenuBack.layoutIfNeeded()
            viewMenuBack.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            viewMenuBack.removeFromSuperview()
        })
    }

}
