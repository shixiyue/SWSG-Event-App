//
//  SignupViewController.swift
//  SWSG
//
//  Created by shixiyue on 11/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

/// `SignUpTableViewController` represents the controller for signup table.
class SignUpTableViewController: UITableViewController, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var signUpButton: RoundCornerButton!
    
    private let countryPickerView = UIPickerView()
    private let imagePicker = UIImagePickerController()
    private let skillsPlaceholder = "Skills"
    private let descPlaceholder = "Description"
    private let passwordInvalid = "Password must be greater than 6 characters."
    private let emailInvalid = "Please enter a valid email address."
    private let signUpProblem = "There was a problem signing up."
    
    @IBOutlet private var signUpTableView: UITableView!

    @IBOutlet private var profileImageButton: UIButton!
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var countryTextField: UITextField!
    @IBOutlet private var jobTextField: UITextField!
    @IBOutlet private var companyTextField: UITextField!
    @IBOutlet private var educationTextField: UITextField!
    @IBOutlet private var skillsTextView: GrayBorderTextView!
    @IBOutlet private var descTextView: GrayBorderTextView!
    
    private var textFields: [UITextField]!

    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.roundUIButton(for: profileImageButton)
        setUpSignUpTableView()
        setUpButton()
        setUpProfileImage()
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
    
    private func setUpProfileImage() {
        imagePicker.delegate = self
        profileImageButton.imageView?.contentMode = .scaleAspectFit
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
    
    @IBAction func changeProfileImage(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        let takePhotoAction = UIAlertAction(title: "Take a photo", style: .default) { action in
            self.takePhoto()
        }
        alertController.addAction(takePhotoAction)
        
        let selectPhotoAction = UIAlertAction(title: "Select a photo", style: .default) { action in
            self.selectPhoto()
        }
        alertController.addAction(selectPhotoAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func takePhoto() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            present(Utility.getFailAlertController(message: "Sorry, this device has no camera"), animated: true, completion: nil)
            return
        }
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        imagePicker.cameraCaptureMode = .photo
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker,animated: true, completion: nil)
    }
    
    private func selectPhoto() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePicker, animated: true, completion: nil)
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
        guard let image = profileImageButton.imageView?.image, let name = nameTextField.text, let email = emailTextField.text?.trim(), let password = passwordTextField.text, let country = countryTextField.text,let job = jobTextField.text, let company = companyTextField.text, let education = educationTextField.text, var skills = skillsTextView.text?.trimTrailingWhiteSpace(), var desc = descTextView.text?.trimTrailingWhiteSpace() else {
            return
        }
        skills = skills.trimTrailingWhiteSpace().isEmpty ? " " : skills
        desc = desc.trimTrailingWhiteSpace().isEmpty ? " " : desc
        guard Utility.isValidPassword(testStr: password) else {
            self.present(Utility.getFailAlertController(message: passwordInvalid), animated: true, completion: nil)
            return
        }
        guard Utility.isValidEmail(testStr: email) else {
            self.present(Utility.getFailAlertController(message: emailInvalid), animated: true, completion: nil)
            return
        }
        let profile = Profile(name: name, image: image, job: job, company: company, country: country,
                              education: education, skills: skills, description: desc)
        let user = Participant(profile: profile, password: password, email: email, team: nil)
        let success = Storage.saveUser(data: user.toDictionary(), fileName: email)
        guard success else {
            self.present(Utility.getFailAlertController(message: signUpProblem), animated: true, completion: nil)
            return
        }

        Utility.logInUser(user: user, currentViewController: self)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            dismiss(animated: true, completion: nil)
            return
        }
        dismiss(animated: true, completion: nil)
        jumpToCropImage(imageToCrop: chosenImage)
    }
    
    private func jumpToCropImage(imageToCrop: UIImage) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.showSpinningWheel(_:)), name: NSNotification.Name(rawValue: Config.image), object: nil)
        
        let storyboard = UIStoryboard(name: "ImageCropper", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ImageCropperViewController") as! ImageCropperViewController
        controller.imageToCrop = imageToCrop
        present(controller, animated: false, completion: nil)
    }
    
    // handle notification
    func showSpinningWheel(_ notification: NSNotification) {
        
        if let image = notification.userInfo?[Config.image] as? UIImage {
            profileImageButton.setImage(image, for: .normal)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
