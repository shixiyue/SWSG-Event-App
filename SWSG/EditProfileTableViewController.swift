//
//  SignupViewController.swift
//  SWSG
//
//  Created by shixiyue on 11/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

/// `SignUpTableViewController` represents the controller for signup table.
class EditProfileTableViewController: UITableViewController, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    var doneButton: RoundCornerButton!
    
    private let countryPickerView = UIPickerView()
    private let skillsPlaceholder = "Skills"
    private let descPlaceholder = "Description"
    private let updateProblem = "There was a problem updating profile."
    
    @IBOutlet private var profileTableView: UITableView!

    @IBOutlet private var profileImage: UIImageView!
    // TODO: Figure out how to allow to upload a new image and change profile picture
    @IBOutlet private var countryTextField: UITextField!
    @IBOutlet private var jobTextField: UITextField!
    @IBOutlet private var companyTextField: UITextField!
    @IBOutlet private var educationTextField: UITextField!
    @IBOutlet private var skillsTextView: GrayBorderTextView!
    @IBOutlet private var descTextView: GrayBorderTextView!
    
    private var textFields: [UITextField]!

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
        textFields = [nameTextField, emailTextField, passwordTextField, countryTextField, jobTextField, companyTextField, educationTextField]
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
            textView.textColor = UIColor.lightGray
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == UIColor.lightGray else {
            return
        }
        textView.text = nil
        textView.textColor = UIColor.black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let textView = textView as? GrayBorderTextView else {
            return
        }
        guard textView.text.isEmpty else {
            return
        }
        textView.setPlaceholder()
        textView.textColor = UIColor.lightGray
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
    }
    
    private func updateButtonState() {
        let isAnyEmpty = textFields.reduce(false, { $0 || ($1.text?.isEmpty ?? true) }) || skillsTextView.text.isEmpty
        signUpButton.isEnabled = !isAnyEmpty
        signUpButton.alpha = isAnyEmpty ? Config.disableAlpha : Config.enableAlpha
    }
    
    @objc private func signUp(sender: UIButton) {
        guard let image = profileImage.image, let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text, let country = countryTextField.text,let job = jobTextField.text, let company = companyTextField.text, let education = educationTextField.text, let skills = skillsTextView.text else {
            return
        }
        let desc = descTextView.text ?? ""
        guard password.characters.count >= Config.passwordMinLength else {
            self.present(Utility.getFailAlertController(message: passwordInvalid), animated: true, completion: nil)
            return
        }
        guard Utility.isValidEmail(testStr: email) else {
            self.present(Utility.getFailAlertController(message: emailInvalid), animated: true, completion: nil)
            return
        }
        // TODO: Figure out how to save image
        let userProfile = [Config.name: name, Config.email: email, Config.password: password, Config.country: country, Config.job: job, Config.company: company, Config.education: education, Config.skills: skills, Config.desc: desc]
        let success = Storage.saveUser(data: userProfile, fileName: email)
        guard success else {
            self.present(Utility.getFailAlertController(message: signUpProblem), animated: true, completion: nil)
            return
        }
        let profile = Profile(name: name, image: image, job: job, company: company, country: country,
        education: education, skills: skills, description: desc)
        let user = Participant(profile: profile, password: password, email: email, team: nil)
        Utility.logInUser(user: user, currentViewController: self)
    }
    
}
