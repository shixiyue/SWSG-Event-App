//
//  MenuViewController.swift
//  SWSG
//
//  Created by Jeremy Jee on 14/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}

class MenuViewController: UIViewController {
    @IBOutlet weak var menuList: UITableView! {
        didSet{
            let tapGesture = UITapGestureRecognizer(target:self,action:#selector(MenuViewController.menuItemTapHandler))
            tapGesture.numberOfTapsRequired = 1
            menuList.addGestureRecognizer(tapGesture)
            menuList.isUserInteractionEnabled = true
            
        }
    }
    @IBOutlet var btnCloseMenuOverlay : UIButton!
    
    var btnMenu : UIButton!
    var delegate : SlideMenuDelegate?
    
    override func viewDidLoad() {
        menuList.delegate = self
        menuList.dataSource = self
    }
    
    @IBAction func onCloseMenuClick(_ button:UIButton!){
        btnMenu.tag = 0
        
        if (self.delegate != nil) {
            var index = Int32(button.tag)
            if(button == self.btnCloseMenuOverlay){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
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
            delegate?.slideMenuItemSelectedAtIndex(Int32(indexPath.item))
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
}
