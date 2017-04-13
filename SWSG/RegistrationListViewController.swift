//
//  RegistrationListViewController.swift
//  SWSG
//
//  Created by Jeremy Jee on 13/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import Firebase

class RegistrationListViewController: UIViewController {
    
    @IBOutlet weak var registrationList: UITableView!
    
    fileprivate var registrationEvents = [RegistrationEvent]()
    
    fileprivate var registrationRef: FIRDatabaseReference?
    fileprivate var regAddHandler: FIRDatabaseHandle?
    fileprivate var regRemovedHandler: FIRDatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registrationList.delegate = self
        registrationList.dataSource = self
        
        observeRegistrationEvents()
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == Config.registrationListToRegistration, let rEvent = sender as? RegistrationEvent {
            guard let registrationVC = segue.destination as? RegistrationViewController else {
                return
            }
            
            registrationVC.registrationEvent = rEvent
        }
    }
    
    func observeRegistrationEvents() {
        registrationRef = System.client.getRegistrationRef()
        
        regAddHandler = registrationRef?.observe(.childAdded, with: { (snapshot) in
            guard let rEvent = RegistrationEvent(id: snapshot.key, snapshot: snapshot) else {
                return
            }
            
            self.registrationEvents.append(rEvent)
            self.registrationList.reloadData()
        })
        
        regRemovedHandler = registrationRef?.observe(.childRemoved, with: { (snapshot) in
            print(snapshot)
            guard let rEvent = RegistrationEvent(id: snapshot.key, snapshot: snapshot) else {
                print("test3")
                return
            }
            
            print("test4")
            for (index, event) in self.registrationEvents.enumerated() {
                if event.id == rEvent.id {
                    self.registrationEvents.remove(at: index)
                    break
                }
            }
            
            print("test2")
            self.registrationList.reloadData()
        })

    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        let title = "Add Registration Event"
        let message = "What is the name of the event?"
        let btnText = "Add"
        let placeholderText = "Event Name"
        
        Utility.createPopUpWithTextField(title: title, message: message,
                                         btnText: btnText, placeholderText: placeholderText,
                                         existingText: "", viewController: self,
                                         completion: { (name) in
            
                                            let registrationEvent = RegistrationEvent(name: name)
                                            System.client.createRegistrationEvent(rEvent: registrationEvent, completion: { (err) in
                                                self.registrationList.reloadData()
                                            })
        })
    }
}

extension RegistrationListViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return registrationEvents.count
    }
    
    public func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let registrationEvent = registrationEvents[indexPath.item]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Config.registrationCell, for: indexPath) as? RegistrationCell else {
                return RegistrationCell()
        }
        
        cell.nameLbl.text = registrationEvent.name
        
        return cell
    }
}

extension RegistrationListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let registrationEvent = registrationEvents[indexPath.item]
        self.performSegue(withIdentifier: Config.registrationListToRegistration, sender: registrationEvent)
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let registrationEvent = registrationEvents[indexPath.row]
            System.client.deleteRegistrationEvent(rEvent: registrationEvent, completion: { (error) in
                
            })
        }
    }
    
}

// MARK: UITextFieldDelegate
extension RegistrationListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
