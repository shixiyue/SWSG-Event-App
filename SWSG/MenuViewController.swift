//
//  MenuViewController.swift
//  SWSG
//
//  Created by Jeremy Jee on 14/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import Firebase

class MenuViewController: UIViewController {
    @IBOutlet weak var menuList: UITableView! {
        didSet{
            let tapGesture = UITapGestureRecognizer(target:self,action:#selector(MenuViewController.menuItemTapHandler))
            tapGesture.numberOfTapsRequired = 1
            menuList.addGestureRecognizer(tapGesture)
            menuList.isUserInteractionEnabled = true
            
        }
    }
    @IBOutlet private var btnCloseMenuOverlay : UIButton!
    @IBOutlet private var profileOverlay: UIButton!
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet private weak var nameLbl: UILabel!
    @IBOutlet private weak var usernameLbl: UILabel!
    @IBOutlet private weak var teamLbl: UILabel!
    
    //MARK: Firebase References
    private var userRef: FIRDatabaseReference?
    private var userRefHandle: FIRDatabaseHandle?
    
    var teams = Teams()
    var btnMenu : UIButton!
    var delegate : SlideMenuDelegate?
    
    override func viewDidLoad() {
        menuList.delegate = self
        menuList.dataSource = self
        menuList.tableFooterView = UIView(frame: CGRect.zero)
        
        guard let uid = System.client.getUid() else {
            Utility.logOutUser(currentViewController: self)
            return
        }
        
        userRef = System.client.getUserRef(for: uid)
        profileImg = Utility.roundUIImageView(for: profileImg)
        profileImg.image = Config.placeholderImg
        
        setUpUserInfo()
        observeImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpUserInfo()
    }
    
    deinit {
        if let refHandle = userRefHandle {
            userRef?.removeObserver(withHandle: refHandle)
        }
    }
    
    private func observeImage() {
        guard let userRef = userRef, let uid = System.activeUser?.uid else {
            return
        }
        
        userRefHandle = userRef.observe(.value, with: { (snapshot) -> Void in
            Utility.getProfileImg(uid: uid, completion: { (image) in
                if let image = image {
                    self.profileImg.image = image
                }
            })
        })
    }
    
    private func setUpUserInfo() {
        guard let user = System.activeUser else {
            Utility.logOutUser(currentViewController: self)
            return
        }
        
        if let img = user.profile.image {
            self.profileImg.image = img
        }
        
        nameLbl.text = user.profile.name
        usernameLbl.text = "@\(user.profile.username)"
        
        guard user.type.isParticipant else {
            teamLbl.text = user.type.toString()
            return
        }
        
        Utility.getTeamLbl(user: user, completion: { (teamLblText) in
            self.teamLbl.text = teamLblText
        })
    }

    @IBAction func onProfileClick(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        if let destViewController = storyboard.instantiateViewController(withIdentifier: Config.profileViewController) as? ProfileViewController {
            destViewController.user = System.activeUser
            
            self.navigationController?.pushViewController(destViewController, animated: true)
        }
    }
    
    @IBAction func onCloseMenuClick(_ button:UIButton!){
        btnMenu.tag = 0
        
        if (self.delegate != nil) {
            var index = button.tag
            if(button == self.btnCloseMenuOverlay){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        closeMenu()
    }
    
    func closeMenu() {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        })
    }
    
    func menuItemTapHandler(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended{
            let point = recognizer.location(in: menuList)
            guard let indexPath = menuList.indexPathForRow(at: point) else {
                return
            }
            delegate?.slideMenuItemSelectedAtIndex(indexPath.item)
        }
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuItems.count
    }
    
    public func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.item
        let item =  MenuItems.items[index]
        
        guard let cell = menuList.dequeueReusableCell(withIdentifier: "menuCell",
                                             for: indexPath) as? MenuCell else {
            return MenuCell()
        }
        
        cell.icon.image = UIImage(named: "\(item).png")
        cell.name.text = item
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        delegate?.slideMenuItemSelectedAtIndex(indexPath.item)
        closeMenu()
    }
}
