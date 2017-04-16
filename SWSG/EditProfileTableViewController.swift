//
//  SignupViewController.swift
//  SWSG
//
//  Created by shixiyue on 11/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import Firebase
import Google
import GoogleSignIn
import FacebookCore
import FacebookLogin
import SwiftSpinner

/// `EditProfileTableViewController` represents the controller for signup table.
class EditProfileTableViewController: UITableViewController {
    
    var doneButton: RoundCornerButton!
    
    @IBOutlet private var profileTableView: UITableView!
    @IBOutlet private var profileImageButton: UIButton!
    @IBOutlet private var changeImageButton: UIButton!
    @IBOutlet private var usernameTextField: UILabel!
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet fileprivate var countryTextField: UITextField!
    @IBOutlet private var jobTextField: UITextField!
    @IBOutlet private var companyTextField: UITextField!
    @IBOutlet private var educationTextField: UITextField!
    @IBOutlet fileprivate var skillsTextView: GrayBorderTextView!
    @IBOutlet private var descTextView: GrayBorderTextView!
    
    @IBOutlet private var googleView: UIView!
    @IBOutlet private var facebookView: UIView!
    
    @IBOutlet weak var unlinkFacebookBtn: UIButton!
    @IBOutlet weak var unlinkGoogleBtn: UIButton!
    @IBOutlet weak var changePasswordBtn: RoundCornerButton!
    
    private let imagePicker = ImagePickCropperPopoverViewController()
    private var user: User!
    
    fileprivate let countryPickerView = UIPickerView()
    fileprivate let fbLoginButton = LoginButton(readPermissions: [.publicProfile, .email])
    fileprivate let googleLoginButton = GIDSignInButton()
    fileprivate var textFields: [UITextField]!
    fileprivate var auth: [AuthType]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUser()
        setUpButton()
        setUpAuthTypes()
        setUpProfileTableView()
        setUpProfileImage()
        setUpTextFields()
        setUpTextViews()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SwiftSpinner.show(Config.loadingData)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    private func setUpUser() {
        guard let user = System.activeUser else {
            Utility.logOutUser(currentViewController: self)
            return
        }
        self.user = user
    }
    
    fileprivate func setUpAuthTypes() {
        auth = [AuthType]()
        
        System.client.checkIfEmailAlreadyExists(email: user.email, completion: { (arr, _) in
            guard let arr = arr else {
                return
            }
            
            for child in arr {
                guard let authType = AuthType(rawValue: child) else {
                    continue
                }
                
                self.auth.append(authType)
            }
            
            self.setUpAuthButtons() 
        })
    }
    
    fileprivate func setUpAuthButtons() {
        Utility.signOutSocialMedia()
        
        if !auth.contains(.email) {
            changePasswordBtn.setTitle(Config.addPassword, for: .normal)
        } else {
            changePasswordBtn.setTitle(Config.changePassword, for: .normal)
        }
        
        if !auth.contains(.facebook) {
            fbLoginButton.isHidden = false
            unlinkFacebookBtn.isHidden = true
        } else if auth.count > 1 {
            fbLoginButton.isHidden = true
            unlinkFacebookBtn.isHidden = false
        } else {
            fbLoginButton.isHidden = true
            unlinkFacebookBtn.isHidden = true
        }
        
        if !auth.contains(.google) {
            googleLoginButton.isHidden = false
            unlinkGoogleBtn.isHidden = true
        } else if auth.count > 1 {
            googleLoginButton.isHidden = true
            unlinkGoogleBtn.isHidden = false
        } else {
            googleLoginButton.isHidden = true
            unlinkGoogleBtn.isHidden = true
        }
        SwiftSpinner.hide()
    }
    
    private func setUpProfileTableView() {
        profileTableView.tableFooterView = UIView(frame: CGRect.zero)
        profileTableView.allowsSelection = false
    }
    
    private func setUpButton() {
        doneButton.addTarget(self, action: #selector(update), for: .touchUpInside)
        
        let googleCenter = CGPoint(x: googleView.frame.width/2,y: googleView.frame.height/2)
        
        googleLoginButton.center = googleCenter
        self.googleView.addSubview(googleLoginButton)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(googleLoginBtnPressed))
        googleLoginButton.addGestureRecognizer(tapGesture)
        googleLoginButton.backgroundColor = Config.greenColor
        
        let fbCenter = CGPoint(x: facebookView.frame.width/2,y: facebookView.frame.height/2)
        
        fbLoginButton.center = fbCenter
        
        fbLoginButton.delegate = self
        self.facebookView.addSubview(fbLoginButton)
    }
    
    private func setUpProfileImage() {
        profileImageButton.setImage(user.profile.image, for: .normal)
        profileImageButton.addTarget(self, action: #selector(editProfileImage), for: .touchUpInside)
        changeImageButton.addTarget(self, action: #selector(editProfileImage), for: .touchUpInside)
    }
    
    func editProfileImage() {
        Utility.showImagePicker(imagePicker: imagePicker, viewController: self, completion: { (image) in
            if let image = image {
                self.profileImageButton.setImage(image, for: .normal)
            }
        })
    }
    
    private func setUpTextFields() {
        textFields = [nameTextField, countryTextField, jobTextField, companyTextField, educationTextField]
        for (index, textField) in textFields.enumerated() {
            textField.delegate = self
            textField.tag = index
        }
        nameTextField.text = user.profile.name
        usernameTextField.text = Config.userNamePrefix + user.profile.username
        countryTextField.text = user.profile.country
        jobTextField.text = user.profile.job
        companyTextField.text = user.profile.company
        educationTextField.text = user.profile.education
        setUpCountryTextField()
    }
    
    private func setUpTextViews() {
        let textViews: [UITextView] = [skillsTextView, descTextView]
        for textView in textViews {
            textView.delegate = self
        }
        skillsTextView.text = user.profile.skills
        descTextView.text = user.profile.desc
    }
    
    private func setUpCountryTextField() {
        setUpCountryPickerView()
        setUpCountryToolBar()
    }
    
    private func setUpCountryPickerView() {
        countryPickerView.showsSelectionIndicator = true
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        countryPickerView.selectRow(Utility.defaultCountryIndex, inComponent: 0, animated: true)
        countryTextField.inputView = countryPickerView
    }
    
    private func setUpCountryToolBar() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = Config.themeColor
        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: Config.done, style: .done, target: self, action: #selector(donePicker))
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        countryTextField.inputAccessoryView = toolBar
    }
    
    @objc private func donePicker(sender: UIBarButtonItem) {
        let row = countryPickerView.selectedRow(inComponent: 0)
        pickerView(countryPickerView, didSelectRow: row, inComponent: 0)
        jobTextField.becomeFirstResponder()
    }
    
    @objc private func update(sender: UIButton) {
        guard System.client.isConnected else {
            present(Utility.getNoInternetAlertController(), animated: true, completion: nil)
            return
        }
        guard let image = profileImageButton.imageView?.image, let name = nameTextField.text, let country = countryTextField.text,let job = jobTextField.text, let company = companyTextField.text, let education = educationTextField.text, let skills = skillsTextView.content, let desc = descTextView.content else {
            return
        }
        user.profile.updateProfile(username: user.profile.username, name: name, image: image, job: job, company: company, country: country, education: education, skills: skills, description: desc)
        System.activeUser?.profile.updateProfile(to: user.profile)
        System.client.updateUser(newUser: user)
        
        Utility.popViewController(no: 1, viewController: self)
    }
    
    @IBAction func unlinkFBBtnPressed(_ sender: Any) {
        guard System.client.isConnected else {
            present(Utility.getNoInternetAlertController(), animated: true, completion: nil)
            return
        }
        let title = Config.removeFacebookTitle
        let message = Config.removeFacebookMessage
        Utility.displayDismissivePopup(title: title, message: message, viewController: self, completion: { () in
            System.client.removeAdditionalAuth(authType: .facebook)
            SwiftSpinner.show(Config.loadingData)
            
            for (index, authType) in self.auth.enumerated() {
                if authType == .facebook {
                    self.auth.remove(at: index)
                }
            }
            
            self.setUpAuthButtons()
        })
    }
    
    @IBAction func unlinkGoogleBtnPressed(_ sender: Any) {
        guard System.client.isConnected else {
            present(Utility.getNoInternetAlertController(), animated: true, completion: nil)
            return
        }
        let title = Config.removeGoogleTitle
        let message = Config.removeGoogleMessage
        Utility.displayDismissivePopup(title: title, message: message, viewController: self, completion: { () in
            System.client.removeAdditionalAuth(authType: .google)
            SwiftSpinner.show(Config.loadingData)
            
            for (index, authType) in self.auth.enumerated() {
                if authType == .google {
                    self.auth.remove(at: index)
                }
            }
            
            self.setUpAuthButtons()
        })
    }
    
    @IBAction func changeBtnPressed(_ sender: Any) {
        guard System.client.isConnected else {
            present(Utility.getNoInternetAlertController(), animated: true, completion: nil)
            return
        }
        if !auth.contains(.email) {
            showAddPassword()
        } else {
            showChangePassword()
        }
    }
    
    fileprivate func showAddPassword() {
        let title = Config.addPassword
        let message = Config.addPasswordMessage
        let btnText = Config.addButtonText
        Utility.createPopUpWithTextField(title: title, message: message, btnText: btnText,
                                         placeholderText: placeholderText, existingText: "",
                                         isSecure: true, viewController: self,
                                         completion: { (password) in
            guard let user = self.user, let credential =
                System.client.getEmailCredential(email: user.email, password: password) else {
                return
            }
            SwiftSpinner.show(Config.loadingData)
            
            System.client.addAdditionalAuth(credential: credential, completion: { (_) in
                self.auth.append(.email)
                
                self.setUpAuthButtons()
            })
        })
    }
    
    fileprivate func showChangePassword() {
        let alertController = UIAlertController(title: Config.changePassword, message: nil, preferredStyle: .alert)
        
        let updateAction = UIAlertAction(title: Config.ok, style: .default) { [weak alertController] _ in
            guard let alertController = alertController else {
                return
            }
            let currentPasswordTextField = alertController.textFields![0] as UITextField
            let newPasswordTextField = alertController.textFields![1] as UITextField
            
            guard let currentPassword = currentPasswordTextField.text,
                let newPassword = newPasswordTextField.text else {
                return
            }
            self.changePassword(from: currentPassword, to: newPassword)
        }
        updateAction.isEnabled = false
        
        let cancelAction = UIAlertAction(title: Config.cancel, style: .cancel)
        
        alertController.addTextField { textField in
            textField.placeholder = Config.currentPassword
            textField.isSecureTextEntry = true
        }
        alertController.addTextField { textField in
            textField.placeholder = Config.newPassword
            textField.isSecureTextEntry = true
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name.UITextFieldTextDidChange,
                                               object: alertController.textFields?[0],
                                               queue: OperationQueue.main) { notification in
            let currentPasswordTextField = alertController.textFields![0] as UITextField
            let newPasswordTextField = alertController.textFields![1] as UITextField
            guard let currentPassword = currentPasswordTextField.text,
                let newPassword = newPasswordTextField.text else {
                return
            }
            
            updateAction.isEnabled = !currentPassword.isEmpty && !newPassword.isEmpty
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name.UITextFieldTextDidChange,
                                               object: alertController.textFields?[1], queue: OperationQueue.main) { notification in
            let currentPasswordTextField = alertController.textFields![0] as UITextField
            let newPasswordTextField = alertController.textFields![1] as UITextField
            guard let currentPassword = currentPasswordTextField.text,
                let newPassword = newPasswordTextField.text else {
                return
            }
            
            updateAction.isEnabled = !currentPassword.isEmpty && !newPassword.isEmpty
        }
        
        alertController.addAction(updateAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func changePassword(from currentPassword: String, to newPassword: String) {
        guard let user = System.activeUser else {
            Utility.logOutUser(currentViewController: self)
            return
        }
        System.client.reauthenticateUser(email: user.email, password: currentPassword, completion: { (error) in
            if let firebaseError = error {
                self.present(Utility.getFailAlertController(message: firebaseError.errorMessage),
                             animated: true, completion: nil)
                return
            }
            System.client.changePassword(newPassword: newPassword, completion: { (error) in
                if let firebaseError = error {
                    self.present(Utility.getFailAlertController(message: firebaseError.errorMessage),
                                 animated: true, completion: nil)
                    return
                }
                self.present(Utility.getSuccessAlertController(), animated: true, completion: nil)
            })
        })
    }

}

extension EditProfileTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Utility.countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Utility.countries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countryTextField.text = Utility.countries[row]
    }
    
}

extension EditProfileTableViewController: UITextViewDelegate, UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if nextTag < textFields.count {
            textFields[nextTag].becomeFirstResponder()
        } else {
            skillsTextView.becomeFirstResponder()
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateButtonState()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        updateButtonState()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateButtonState()
    }
    
    private func updateButtonState() {
        let isAnyEmpty = textFields.reduce(false, {
            $0 || ($1.text?.isEmptyContent ?? true) }) || skillsTextView.isEmpty
        doneButton.isEnabled = !isAnyEmpty
        doneButton.alpha = isAnyEmpty ? Config.disableAlpha : Config.enableAlpha
    }
    
}

extension EditProfileTableViewController: GIDSignInDelegate, GIDSignInUIDelegate {
    func googleLoginBtnPressed(sender: UITapGestureRecognizer) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil, let credential = System.client.getGoogleCredential() else {
            return
        }
        

        System.client.addAdditionalAuth(credential: credential, completion: { (_) in
            SwiftSpinner.show(Config.communicateGoogle)
            self.auth.append(.google)
            
            self.setUpAuthButtons()
        })
        
    }
}

extension EditProfileTableViewController: LoginButtonDelegate {
    func loginButtonDidCompleteLogin(_ fbLoginButton: LoginButton, result: LoginResult) {
        System.client.getFBProfile(completion: { (_, error) in
            guard error == nil, let credential = System.client.getFBCredential() else {
                return
            }
            
            System.client.addAdditionalAuth(credential: credential, completion: { (_) in
                SwiftSpinner.show(Config.commucateFacebook)
                
                self.auth.append(.facebook)
                
                self.setUpAuthButtons()
            })
            
        })
    }
    
    func loginButtonDidLogOut(_ fbLoginButton: LoginButton) {
        
    }
}
