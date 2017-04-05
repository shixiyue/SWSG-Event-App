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

/// `SignUpTableViewController` represents the controller for signup table.
class SignUpTableViewController: ImagePickerTableViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var signUpButton: RoundCornerButton!
    
    private let countryPickerView = UIPickerView()
    private let skillsPlaceholder = "Skills"
    private let descPlaceholder = "Description"
    
    @IBOutlet fileprivate var signUpTableView: UITableView!

    @IBOutlet private var profileImageButton: UIButton!
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var usernameTextField: UITextField!
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var countryTextField: UITextField!
    @IBOutlet private var jobTextField: UITextField!
    @IBOutlet private var companyTextField: UITextField!
    @IBOutlet private var educationTextField: UITextField!
    @IBOutlet fileprivate var skillsTextView: GrayBorderTextView!
    @IBOutlet fileprivate var descTextView: GrayBorderTextView!
    
    @IBOutlet fileprivate var skillsTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var descTextViewHeightConstraint: NSLayoutConstraint!
    
    fileprivate var textFields: [UITextField]!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSignUpTableView()
        setUpButton()
        setUpTextFields()
        setUpTextViews()
        hideKeyboardWhenTappedAround()
    }
    
    private func setUpSignUpTableView() {
        signUpTableView.tableFooterView = UIView(frame: CGRect.zero)
        signUpTableView.allowsSelection = false
    }
    
    private func setUpButton() {
        signUpButton.setDisable()
        signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
    }
    
    private func setUpTextFields() {
        textFields = [nameTextField, usernameTextField, emailTextField, passwordTextField, countryTextField, jobTextField, companyTextField, educationTextField]
        for (index, textField) in textFields.enumerated() {
            textField.delegate = self
            textField.tag = index
        }
        setUpCountryTextField()
    }
    
    private func setUpTextViews() {
        let textViews: [UITextView] = [skillsTextView, descTextView]
        for textView in textViews {
            textView.delegate = self
        }
        skillsTextView.setPlaceholder(skillsPlaceholder)
        descTextView.setPlaceholder(descPlaceholder)
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
    
    @IBAction func changeProfileImage(_ sender: UIButton) {
        alertControllerPosition = CGPoint(x: view.frame.width / 2, y: profileImageButton.bounds.maxY)
        showImageOptions()
    }
    
    @objc private func signUp(sender: UIButton) {
        guard let image = profileImageButton.imageView?.image, let name = nameTextField.text, let username = usernameTextField.text, let email = emailTextField.text?.trim(), let password = passwordTextField.text, let country = countryTextField.text,let job = jobTextField.text, let company = companyTextField.text, let education = educationTextField.text, let skills = skillsTextView.content, let desc = descTextView.content else {
            return
        }
        //TODO: Removed line: let type = Storage.retrieveUserType(email: email)
        let type = UserTypes(isParticipant: true, isSpeaker: false, isMentor: false, isOrganizer: false, isAdmin: false)
        let profile = Profile(name: name, username: username, image: image, job: job, company: company, country: country,
                              education: education, skills: skills, description: desc)
        let user = User(profile: profile, type: type, email: email)
        System.client.createNewUser(user, email: email, password: password, completion: { (error) in
            if let firebaseError = error {
                self.present(Utility.getFailAlertController(message: firebaseError.errorMessage), animated: true, completion: nil)
            } else {
                Utility.logInUser(user: user, currentViewController: self)
            }
        })
    }
    
    override func updateImage(to image: UIImage) {
        profileImageButton.setImage(image, for: .normal)
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension SignUpTableViewController: UITextViewDelegate, UITextFieldDelegate {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1;
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
        updateTextViewHeight(textView)
    }
    
    private func updateButtonState() {
        let isAnyEmpty = textFields.reduce(false, { $0 || ($1.text?.isEmpty ?? true) }) || skillsTextView.isEmpty
        signUpButton.isEnabled = !isAnyEmpty
        signUpButton.alpha = isAnyEmpty ? Config.disableAlpha : Config.enableAlpha
    }
    
    private func updateTextViewHeight(_ textView: UITextView) {
        var constraint: NSLayoutConstraint = skillsTextViewHeightConstraint
        if textView == descTextView  {
            constraint = descTextViewHeightConstraint
        }
        let size = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        
        guard size.height != constraint.constant, size.height >= Config.minimumProfileTextFieldHeight else {
            return
        }
        constraint.constant = size.height
        textView.setContentOffset(CGPoint(), animated: false)
        UIView.setAnimationsEnabled(false)
        signUpTableView.beginUpdates()
        signUpTableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard let textView = textView as? GrayBorderTextView, let currentText = textView.text else {
            return false
        }
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if updatedText.isEmpty {
            textView.setPlaceholder()
            updateButtonState()
            return false
        } else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.removePlaceholder()
            updateButtonState()
        }
        return true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        guard view.window != nil, textView.textColor == UIColor.lightGray else {
            return
        }
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
    }
    
}
