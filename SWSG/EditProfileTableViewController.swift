//
//  SignupViewController.swift
//  SWSG
//
//  Created by shixiyue on 11/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

/// `EditProfileTableViewController` represents the controller for signup table.
// TODO: Is it possible to share the view controller?
class EditProfileTableViewController: UITableViewController, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    var doneButton: RoundCornerButton!
    
    private let countryPickerView = UIPickerView()
    private let skillsPlaceholder = "Skills"
    private let descPlaceholder = "Description"
    private let updateProblem = "There was a problem updating profile."
    
    private var user: User!
    
    @IBOutlet private var profileTableView: UITableView!
    @IBOutlet private var profileImage: UIImageView!
    // TODO: Figure out how to allow to upload a new image and change profile picture
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var countryTextField: UITextField!
    @IBOutlet private var jobTextField: UITextField!
    @IBOutlet private var companyTextField: UITextField!
    @IBOutlet private var educationTextField: UITextField!
    @IBOutlet private var skillsTextView: GrayBorderTextView!
    @IBOutlet private var descTextView: GrayBorderTextView!
    
    private var textFields: [UITextField]!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUser()
        setUpProfileTableView()
        setUpButton()
        setUpTextFields()
        setUpTextViews()
        hideKeyboardWhenTappedAround()
    }
    
    private func setUpUser() {
        guard let user = System.activeUser else {
            Utility.logOutUser(currentViewController: self)
            return
        }
        self.user = user
    }
    
    private func setUpProfileTableView() {
        profileTableView.tableFooterView = UIView(frame: CGRect.zero)
        profileTableView.allowsSelection = false
    }
    
    private func setUpButton() {
        doneButton.addTarget(self, action: #selector(update), for: .touchUpInside)
    }
    
    private func setUpTextFields() {
        textFields = [nameTextField, countryTextField, jobTextField, companyTextField, educationTextField]
        for (index, textField) in textFields.enumerated() {
            textField.delegate = self
            textField.tag = index
        }
        nameTextField.text = user.profile.name
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == UIColor.lightGray, let textView = textView as? GrayBorderTextView else {
            return
        }
        textView.removePlaceholder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let textView = textView as? GrayBorderTextView else {
            return
        }
        guard textView.text.isEmpty else {
            return
        }
        textView.setPlaceholder()
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
        doneButton.isEnabled = !isAnyEmpty
        doneButton.alpha = isAnyEmpty ? Config.disableAlpha : Config.enableAlpha
    }
    
    @objc private func update(sender: UIButton) {
        guard let image = profileImage.image, let name = nameTextField.text, let country = countryTextField.text,let job = jobTextField.text, let company = companyTextField.text, let education = educationTextField.text, var skills = skillsTextView.text, var desc = descTextView.text else {
            return
        }
        skills = skills.trimTrailingWhiteSpace().isEmpty ? " " : skills.trimTrailingWhiteSpace()
        desc = desc.trimTrailingWhiteSpace().isEmpty ? " " : desc.trimTrailingWhiteSpace()
        user.profile.updateProfile(name: name, image: image, job: job, company: company, country: country, education: education, skills: skills, description: desc)
        System.activeUser = user
        let success = Storage.saveUser(data: user.toDictionary(), fileName: user.email)
        guard success else {
            self.present(Utility.getFailAlertController(message: updateProblem), animated: true, completion: nil)
            return
        }
        dismiss(animated: false, completion: nil)
    }
}