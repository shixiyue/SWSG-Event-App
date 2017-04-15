//
//  RegistrationViewController.swift
//  SWSG
//
//  Created by Jeremy Jee on 13/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import QRCodeReader

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var cameraBtn: UIBarButtonItem!
    @IBOutlet weak var registeredList: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var registrationEvent: RegistrationEvent?
    fileprivate var registeredUsers = [User]()
    fileprivate var filteredRUsers = [User]()
    fileprivate var searchActive = false
    
    fileprivate var registrationEventRef: FIRDatabaseReference?
    fileprivate var rUserAddedHandle: FIRDatabaseHandle?
    fileprivate var rUserRemovedHandle: FIRDatabaseHandle?
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode], captureDevicePosition: .back)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registeredList.delegate = self
        registeredList.dataSource = self
        
        self.title = registrationEvent?.name
        
        setUpSearchBar()
        observeRegistrationEvent()
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == Config.registrationToProfile, let rUser = sender as? User {
            guard let profileVC = segue.destination as? ProfileViewController else {
                return
            }
            
            profileVC.user = rUser
        }
    }
    
    fileprivate func setUpSearchBar() {
        Utility.setUpSearchBar(searchBar, viewController: self, selector: #selector(donePressed))
    }
    
    func donePressed() {
        self.view.endEditing(true)
    }
    
    private func observeRegistrationEvent() {
        guard let registrationEvent = registrationEvent, let id = registrationEvent.id else {
            return
        }
        
        registrationEventRef = System.client.getRegisteredEventRef(id: id)
        
        let registeredUsersRef = registrationEventRef?.child(Config.registeredUsers)
        
        rUserAddedHandle = registeredUsersRef?.observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            guard let id = snapshot.value as? String else {
                return
            }
            
            System.client.getUserWith(uid: id, completion: { (user, error) in
                if let user = user {
                    self.registeredUsers.append(user)
                    self.registeredList.reloadData()
                }
            })
        })
        
        rUserRemovedHandle = registeredUsersRef?.observe(.childRemoved, with: { (snapshot) in
            guard let id = snapshot.value as? String, let registrationEvent = self.registrationEvent else {
                return
            }
            
            for (index, user) in self.registeredUsers.enumerated() {
                if id == user.uid {
                    self.registeredUsers.remove(at: index)
                }
            }
            
            for (index, userUID) in registrationEvent.registeredUsers.enumerated() {
                if id == userUID {
                    self.registrationEvent?.registeredUsers.remove(at: index)
                }
            }
        })
    }
    
    @IBAction func cameraBtn(_ sender: Any) {
        // Retrieve the QRCode content
        // By using the delegate pattern
        readerVC.delegate = self
        
        // Or by using the closure pattern
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            guard let result = result else {
                return
            }
            
            let username = result.value
            self.registerUser(username: username)
        }
        
        // Presents the readerVC as modal form sheet
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true, completion: nil)
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        if usernameTF.text?.trimmingCharacters(in: .whitespaces) != "" {
            registerUser(username: usernameTF.text!)
        }
    }
    
    func registerUser(username: String) {
        guard let registrationEvent = registrationEvent else {
            return
        }
        
        System.client.getUserWith(username: username, completion: { (user, error) in
            guard let user = user, let uid = user.uid else {
                let title = "Error"
                let message = "Invalid username"
                Utility.displayDismissivePopup(title: title, message: message, viewController: self, completion: { () in })
                return
            }
            
            guard !registrationEvent.registeredUsers.contains(uid) else {
                let title = "Error"
                let message = "\(username) has already been registered"
                Utility.displayDismissivePopup(title: title, message: message, viewController: self, completion: { () in })
                return
            }
            
            registrationEvent.registerUser(uid: uid)
            
            System.client.editRegistrationEvent(rEvent: registrationEvent, completion: { (error) in
                
                let title = "Registered"
                let message = "\(username) has been registered"
                Utility.displayDismissivePopup(title: title, message: message, viewController: self, completion: { () in
                    self.usernameTF.text = ""
                })
            })
        })
    }
}

extension RegistrationViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filteredRUsers.count
        } else {
            return registeredUsers.count
        }
    }
    
    public func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let registeredUser: User
        
        if searchActive && filteredRUsers.count > indexPath.item {
            registeredUser = filteredRUsers[indexPath.item]
        } else {
            registeredUser = registeredUsers[indexPath.item]
        }
        
        guard let uid = registeredUser.uid,
            let cell = tableView.dequeueReusableCell(
            withIdentifier: Config.registeredUserCell, for: indexPath) as? RegisteredUserCell else {
                return RegisteredUserCell()
        }
        
        cell.iconIV = Utility.roundUIImageView(for: cell.iconIV)
        cell.iconIV.image = Config.placeholderImg
        
        Utility.getProfileImg(uid: uid, completion: { (image) in
            if let image = image {
                cell.iconIV.image = image
            }
        })
        
        cell.nameLbl.text = "\(registeredUser.profile.name) (@\(registeredUser.profile.username))"
        
        return cell
    }
}

extension RegistrationViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let registeredUser: User
        
        if searchActive && filteredRUsers.count > indexPath.item {
            registeredUser = filteredRUsers[indexPath.item]
        } else {
            registeredUser = registeredUsers[indexPath.item]
        }
        
        self.performSegue(withIdentifier: Config.registrationToProfile, sender: registeredUser)
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, let registrationEvent = self.registrationEvent {
            let registeredUser = registeredUsers[indexPath.row]
            registeredUsers.remove(at: indexPath.row)
            
            for (index, userID) in registrationEvent.registeredUsers.enumerated() {
                if userID == registeredUser.uid {
                    self.registrationEvent?.registeredUsers.remove(at: index)
                    break
                }
            }
            
            self.registeredList.reloadData()
        }
    }
}

extension RegistrationViewController: QRCodeReaderViewControllerDelegate {
    // Good practice: create the reader lazily to avoid cpu overload during the
    // initialization and each time we need to scan a QRCode
    
    // MARK: - QRCodeReaderViewController Delegate Methods
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
}

// MARK: UISearchBarDelegate
extension RegistrationViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredRUsers = registeredUsers.filter { rUser in
            return rUser.profile.name.lowercased().contains(searchText.lowercased()) ||
                rUser.profile.username.lowercased().contains(searchText.lowercased())
        }
        
        if searchText.characters.count == 0 {
            searchActive = false
        } else {
            searchActive = true
        }
        
        registeredList.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
}

