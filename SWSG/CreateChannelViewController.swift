//
//  CreateChannelViewController.swift
//  SWSG
//
//  Created by Jeremy Jee on 23/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import Firebase

class CreateChannelViewController: ImagePickerViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var memberTF: UITextField!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var memberList: UITableView!
    @IBOutlet weak var iconIV: UIImageView!

    fileprivate let client = System.client
    fileprivate var members = [User]()
    fileprivate var iconAdded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTF.delegate = self
        memberTF.delegate = self
        doneBtn.isEnabled = false
        
        btnNotifier(textField: nameTF, button: doneBtn)
        btnNotifier(textField: memberTF, button: addBtn)
        
        members.append(System.activeUser!)
        
        memberList.delegate = self
        memberList.dataSource = self
        
        iconIV = Utility.roundUIImageView(for: iconIV)
        iconIV.image = UIImage(named: "Placeholder")
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showImageOptions))
        iconIV.addGestureRecognizer(gestureRecognizer)
        editBtn.addTarget(self, action: #selector(showImageOptions), for: .touchUpInside)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        guard let name = nameTF.text else {
            return
        }
        
        var image: UIImage? = nil
        
        if iconAdded {
            image = iconIV.image
        }
        
        client.createChannel(icon: image, name: name, members: members)
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        addMember()
    }
    
    fileprivate func addMember() {
        guard let username = memberTF.text else {
            return
        }
        
        client.getUserWith(username: username, completion: { (user, error) in
            guard let user = user else {
                self.displayDismissivePopup(title: "Error", message: "Username does not exist!")
                return
            }
            
            self.client.fetchProfileImage(for: user.uid!, completion: { (image) in
                user.profile.updateImage(image: image)
                self.memberList.reloadData()
            })
            
            self.members.append(user)
            self.memberList.reloadData()
            self.memberTF.text = ""
            self.view.endEditing(true)
        })
    }
    
    override func updateImage(_ notification: NSNotification) {
        guard let image = notification.userInfo?[Config.image] as? UIImage else {
            return
        }
        iconIV.image = image
        iconAdded = true
    }
    
    private func btnNotifier(textField: UITextField, button: Any) {
        guard (button is UIButton || button is UIBarButtonItem) else {
            return
        }
        
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.UITextFieldTextDidChange,
            object: textField, queue: OperationQueue.main) { _ in
                guard var text = textField.text else {
                    return
                }
                text = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                
                if let button = button as? UIButton {
                    if text != "" {
                        button.isEnabled = true
                    } else {
                        button.isEnabled = false
                    }
                } else if let button = button as? UIBarButtonItem {
                    if text != "" {
                        button.isEnabled = true
                    } else {
                        button.isEnabled = false
                    }
                }
                
        }
    }
    
    private func displayDismissivePopup(title: String, message: String) {
        let dismissController = UIAlertController(title: title, message: message,
                                               preferredStyle: UIAlertControllerStyle.alert)
        
        //Add an Action to Confirm quitting with the Destructive Style
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default) { _ in
        }
        dismissController.addAction(dismissAction)
        
        //Present the Popup
        self.present(dismissController, animated: true, completion: nil)
    }
}

// MARK: UITextFieldDelegate
extension CreateChannelViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == memberTF {
            addMember()
        }
        
        self.view.endEditing(true)
        return false
    }
}

// MARK: UITableViewDataSource
extension CreateChannelViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    public func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Config.memberCell,
                                                      for: indexPath) as? MemberCell else {
                                                        return MemberCell()
        }
        
        let index = indexPath.item
        let member = members[index]
        
        cell.iconIV.image = member.profile.image
        cell.iconIV = Utility.roundUIImageView(for: cell.iconIV)
        cell.nameLbl.text = "\(member.profile.name) (@\(member.profile.username))"
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension CreateChannelViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            members.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.item == 0 {
            return false
        } else {
            return true
        }
    }

}


