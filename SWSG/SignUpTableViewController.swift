//
//  SignupViewController.swift
//  SWSG
//
//  Created by shixiyue on 11/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FacebookCore
import FacebookLogin

/**
 SignUpTableViewController is a UIViewController that displays the Form for Sign Up
 
 Specifications:
 - socialUser: Existing Details from a Social Media Login, an optional value
               Details would be used to fill Name, Email and Profile Image
 */
class SignUpTableViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet fileprivate var scrollView: UIScrollView!
    @IBOutlet private var profileIV: UIImageView!
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var usernameTextField: UITextField!
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet fileprivate var countryTextField: UITextField!
    @IBOutlet private var jobTextField: UITextField!
    @IBOutlet private var companyTextField: UITextField!
    @IBOutlet fileprivate var educationTextView: PlaceholderTextView!
    @IBOutlet fileprivate var skillsTextView: PlaceholderTextView!
    @IBOutlet fileprivate var descTextView: PlaceholderTextView!
    @IBOutlet weak var passwordStackView: UIView!
    @IBOutlet fileprivate var educationTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var skillsTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var descTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var stackViewHeightConstraint: NSLayoutConstraint!
    
    //MARK: Properties
    fileprivate var textFields: [UITextField]!
    fileprivate var textViews: [UITextView]!
    fileprivate var toolbar = UIToolbar()
    fileprivate var activeTextField: UITextField?
    fileprivate var activeTextView: UITextView?
    fileprivate var imagePicker = ImagePickCropperPopoverViewController()
    fileprivate var profileImgSet = false
    fileprivate var currentCredential: FIRAuthCredential?
    fileprivate let countryPickerView = UIPickerView()
    
    var socialUser: SocialUser?
    var signUpButton: RoundCornerButton!
    var loginStack: UIStackView!

    //MARK: Initialization Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButtons()
        setUpTextFields()
        setUpToolbar()
        addKeyboardNotifications()
        setUpTextViews()
        hideKeyboardWhenTappedAround()
        setUpSocialDetails()
    }
    
    private func setUpButtons() {
        signUpButton.setDisable()
        signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showImagePicker))
        profileIV.addGestureRecognizer(tapGesture)
        
        profileIV = Utility.roundUIImageView(for: profileIV)
    }
    
    private func setUpTextFields() {
        textFields = [nameTextField, usernameTextField, emailTextField, countryTextField, jobTextField, companyTextField]
        
        if socialUser == nil {
            textFields.insert(passwordTextField, at: 3)
        }
        
        for (index, textField) in textFields.enumerated() {
            textField.delegate = self
            textField.tag = index
        }
        setUpCountryTextField()
    }
    
    private func setUpToolbar() {
        toolbar = Utility.getToolbar(previous: #selector(previousTextField), next: #selector(nextTextField), done: #selector(donePressed))
    }
    
    private func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func setUpTextViews() {
        textViews = [educationTextView, skillsTextView, descTextView]
        
        
        for (index, textView) in textViews.enumerated() {
            textView.delegate = self
            textView.tag = index
        }
        
        educationTextView.setPlaceholder(Config.educationPlaceholder)
        skillsTextView.setPlaceholder(Config.skillsPlaceholder)
        descTextView.setPlaceholder(Config.descPlaceholder)
    }
    
    private func setUpCountryTextField() {
        setUpCountryPickerView()
    }
    
    private func setUpCountryPickerView() {
        countryPickerView.showsSelectionIndicator = true
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        countryPickerView.selectRow(Utility.defaultCountryIndex, inComponent: 0, animated: true)
        countryTextField.inputView = countryPickerView
    }
    
    private func setUpSocialDetails() {
        guard let socialUser = socialUser else {
            return
        }
        
        let image = socialUser.getProfileImage()
        self.profileIV.image = image
        
        nameTextField.text = socialUser.name
        emailTextField.text = socialUser.email
        emailTextField.isEnabled = false
        passwordStackView.isHidden = true
        loginStack.isHidden = true
    }
    
    //MAR: Handle User Interactions
    @objc private func donePicker(sender: UIBarButtonItem) {
        let row = countryPickerView.selectedRow(inComponent: 0)
        pickerView(countryPickerView, didSelectRow: row, inComponent: 0)
        jobTextField.becomeFirstResponder()
    }
    
    @IBAction func changeProfileImage(_ sender: UIButton) {
        showImagePicker()
    }
    
    func showImagePicker() {
        Utility.showImagePicker(imagePicker: imagePicker, viewController: self, completion: { (image) in
            if let image = image {
                self.profileIV.image = image
                self.profileImgSet = true
            }
            self.textFields.first?.becomeFirstResponder()
        })
    }
    
    @objc private func signUp(sender: UIButton) {
        guard System.client.isConnected else {
            present(Utility.getNoInternetAlertController(), animated: true, completion: nil)
            return
        }
        guard let name = nameTextField.text, let username = usernameTextField.text, let email = emailTextField.text?.trim(), let password = passwordTextField.text, let country = countryTextField.text, let job = jobTextField.text, let company = companyTextField.text, let education = educationTextView.text, let skills = skillsTextView.content, let desc = descTextView.content else {
            return
        }
        
        var image = profileIV.image
        
        if !profileImgSet {
            image = nil
        }
        
        Utility.attemptRegistration(email: email, auth: .email, newCredential: nil, viewController: self, completion: { (exists, arr) in
            
            if let arr = arr {
                let title = Config.emailExists
                let message = Config.logInWithOriginal
                Utility.displayDismissivePopup(title: title, message: message, viewController: self, completion: { () in
                    
                    self.currentCredential = System.client.getEmailCredential(email: email, password: password)
                    self.performSegue(withIdentifier: Config.signUpToLogin, sender: arr)
                })
            } else {
                //Account does not exist, proceed with registration
                let type = UserTypes(isParticipant: true, isSpeaker: false, isMentor: false, isOrganizer: false, isAdmin: false)
                
                
                let profile = Profile(name: name, username: username, image: image, job: job, company: company, country: country,
                                      education: education, skills: skills, description: desc)
                let user = User(profile: profile, type: type, email: email)
                
                if let socialUser = self.socialUser {
                    switch socialUser.type {
                    case .facebook:
                        guard let credential = System.client.getFBCredential() else {
                            return
                        }
                        System.client.createNewUser(user, credential: credential, completion: { (error) in
                            self.completeSignUp(user: user, error: error)
                        })
                    case .google:
                        guard let credential = System.client.getGoogleCredential() else {
                            return
                        }
                        System.client.createNewUser(user, credential: credential, completion: { (error) in
                            self.completeSignUp(user: user, error: error)
                        })
                    default:
                        return
                    }
                } else {
                    System.client.createNewUser(user, email: email, password: password, completion: { (error) in
                        self.completeSignUp(user: user, error: error)
                    })
                }
            }
        })
    }
    
    private func completeSignUp(user: User, error: FirebaseError?) {
        if let firebaseError = error {
            self.present(Utility.getFailAlertController(message: firebaseError.errorMessage), animated: true, completion: nil)
        } else {
            Utility.logInUser(user: user, currentViewController: self)
        }
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == Config.signUpToLogin, let arr = sender as? [String] {
            guard let loginVC = segue.destination as? LoginViewController else {
                return
            }
            
            loginVC.newCredential = currentCredential
            loginVC.clientArr = arr
        }
    }
    
}

//MARK: UIPickerViewDataSource, UIPickerViewDelegate
extension SignUpTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {
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

//MARK: UITextViewDelegate, UITextFieldDelegate
extension SignUpTableViewController: UITextViewDelegate, UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.inputAccessoryView = toolbar
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nextTextField()
        
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        adjustOffset(minY: textField.superview?.frame.minY)
        updateButtonState()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        activeTextField = nil
        updateButtonState()
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.inputAccessoryView = toolbar
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeTextView = textView
        adjustOffset(minY: textView.superview?.frame.minY)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        activeTextView = nil
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateButtonState()
        updateTextViewHeight(textView)
    }
    
    private func adjustOffset(minY: CGFloat?) {
        guard let minY = minY else {
            return
        }
        let offset = scrollView.contentOffset
        scrollView.contentOffset = CGPoint(x: offset.x, y: minY - Config.scrollViewOffset)
    }
    
    private func updateButtonState() {
        let isAnyEmpty = textFields.reduce(false, { $0 || ($1.text?.isEmptyContent ?? true) }) || educationTextView.isEmpty || skillsTextView.isEmpty
        signUpButton.isEnabled = !isAnyEmpty
        signUpButton.alpha = isAnyEmpty ? Config.disableAlpha : Config.enableAlpha
    }
    
    private func updateTextViewHeight(_ textView: UITextView) {
        var layoutConstraint: NSLayoutConstraint?
        
        switch textView {
        case educationTextView:
            layoutConstraint = educationTextViewHeightConstraint
        case skillsTextView:
            layoutConstraint = skillsTextViewHeightConstraint
        case descTextView:
            layoutConstraint = descTextViewHeightConstraint
        default:
            break
        }
        
        guard let constraint = layoutConstraint else {
            return
        }
        
        let height = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude)).height + Config.headerBuffer
        
        guard height != constraint.constant, height >= Config.minimumProfileTextFieldHeight else {
            return
        }
        
        stackViewHeightConstraint.constant += height - constraint.constant
        constraint.constant = height
        textView.setContentOffset(CGPoint(), animated: false)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard let textView = textView as? PlaceholderTextView, let currentText = textView.text else {
            return false
        }
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if updatedText.isEmpty {
            textView.setPlaceholder()
            updateButtonState()
            return false
        } else if textView.textColor == Config.placeholderColor && !text.isEmpty {
            textView.removePlaceholder()
            updateButtonState()
        }
        return true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        guard view.window != nil, textView.textColor == Config.placeholderColor else {
            return
        }
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
    }
    
    func previousTextField() {
        Utility.previousTextField(runFirst: saveSelectedRow, activeTF: activeTextField, tfCollection: textFields, activeTV: activeTextView, tvCollection: textViews)
    }
    
    func nextTextField() {
        Utility.nextTextField(runFirst: saveSelectedRow, runLast: donePressed, activeTF: activeTextField, tfCollection: textFields, activeTV: activeTextView, tvCollection: textViews)
    }
    
    func donePressed() {
        Utility.donePressed(runFirst:saveSelectedRow, viewController: self)
    }
    
    func saveSelectedRow() {
        if activeTextField == countryTextField {
            let row = countryPickerView.selectedRow(inComponent: 0)
            countryTextField.text = Utility.countries[row]
        }
    }
    
    //When the keyboard shows, shift the UIView upwards
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey]
            as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= (keyboardSize.height - Config.keyboardOffsetSignUp)
            }
        }
    }
    
    //When the keyboard closes, shift the UIView Back
    func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
        let minOffset: CGFloat = 0
        let maxOffset = scrollView.contentSize.height - scrollView.bounds.size.height
        if scrollView.contentOffset.y < minOffset {
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: minOffset)
        } else if scrollView.contentOffset.y > maxOffset {
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: maxOffset)
        }
    }
    
}
