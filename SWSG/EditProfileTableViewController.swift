//
//  SignupViewController.swift
//  SWSG
//
//  Created by shixiyue on 11/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

/// `EditProfileTableViewController` represents the controller for signup table.
class EditProfileTableViewController: ImagePickerViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var doneButton: RoundCornerButton!
    
    private let countryPickerView = UIPickerView()
    private let skillsPlaceholder = "Skills"
    private let descPlaceholder = "Description"
    private let updateProblem = "There was a problem updating profile."
    
    private var user: User!
    
    @IBOutlet private var profileTableView: UITableView!
    @IBOutlet private var profileImageButton: UIButton!
    @IBOutlet var changeImageButton: UIButton!
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var countryTextField: UITextField!
    @IBOutlet private var jobTextField: UITextField!
    @IBOutlet private var companyTextField: UITextField!
    @IBOutlet private var educationTextField: UITextField!
    @IBOutlet fileprivate var skillsTextView: GrayBorderTextView!
    @IBOutlet private var descTextView: GrayBorderTextView!
    
    fileprivate var textFields: [UITextField]!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUser()
        setUpProfileTableView()
        setUpButton()
        setUpProfileImage()
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
    
    private func setUpProfileImage() {
        profileImageButton.setImage(user.profile.image, for: .normal)
        profileImageButton.addTarget(self, action: #selector(showProfileImageOptions), for: .touchUpInside)
        changeImageButton.addTarget(self, action: #selector(showProfileImageOptions), for: .touchUpInside)
        alertControllerPosition = CGPoint(x: view.frame.width / 2, y: profileImageButton.bounds.maxY)
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
    
    @objc private func update(sender: UIButton) {
        guard let image = profileImageButton.imageView?.image, let name = nameTextField.text, let country = countryTextField.text,let job = jobTextField.text, let company = companyTextField.text, let education = educationTextField.text, let skills = skillsTextView.content, let desc = descTextView.content else {
            return
        }
        user.profile.updateProfile(name: name, image: image, job: job, company: company, country: country, education: education, skills: skills, description: desc)
        System.updateActiveUser()
        let success = Storage.saveUser(user: user)
        guard success else {
            self.present(Utility.getFailAlertController(message: updateProblem), animated: true, completion: nil)
            return
        }
        dismiss(animated: false, completion: nil)
    }
    
    override func updateImage(_ notification: NSNotification) {
        guard let image = notification.userInfo?[Config.image] as? UIImage else {
            return
        }
        profileImageButton.setImage(image, for: .normal)
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension EditProfileTableViewController: UITextViewDelegate, UITextFieldDelegate {
    
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
    
}
