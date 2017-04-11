//
//  CreateEventViewController.swift
//  SWSG
//
//  Created by Jeremy Jee on 10/4/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController {
    
    @IBOutlet weak var imageIV: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var startTimeTF: UITextField!
    @IBOutlet weak var endTimeTF: UITextField!
    @IBOutlet weak var venueTF: UITextField!
    @IBOutlet weak var shortDescTV: PlaceholderTextView!
    @IBOutlet weak var fullDescTV: PlaceholderTextView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var createBtn: RoundCornerButton!
    
    var textFields: [UITextField]!
    var textViews: [PlaceholderTextView]!
    
    fileprivate let datePicker = UIDatePicker()
    fileprivate let sTimePicker = UIDatePicker()
    fileprivate let eTimePicker = UIDatePicker()
    
    fileprivate var toolbar = UIToolbar()
    fileprivate var activeTextField: UITextField?
    fileprivate var activeTextView: UITextView?
    fileprivate let imagePicker = ImagePickerPopoverViewController()
    fileprivate var imageChanged = false
    
    override func viewDidLoad() {
        setUpImageView()
        setUpToolbar()
        setUpTextFields()
        setUpTextViews()
        addKeyboardNotifications()
        setUpPickers()
    }
    
    private func setUpImageView() {
        imageIV = Utility.roundUIImageView(for: imageIV)
        imageIV.image = Config.placeholderImg
        imageIV.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showImagePicker))
        imageIV.addGestureRecognizer(gesture)
    }
    
    private func setUpToolbar() {
        toolbar = Utility.getToolbar(previous: #selector(previousTextField), next: #selector(nextTextField), done: #selector(donePressed))
    }
    
    private func setUpTextFields() {
        textFields = [nameTF, dateTF, startTimeTF, endTimeTF, venueTF]
        
        for (index, textField) in textFields.enumerated() {
            textField.inputAccessoryView = toolbar
            textField.tag = index
            textField.delegate = self
        }
    }
    
    private func setUpTextViews() {
        textViews = [shortDescTV, fullDescTV]
        
        shortDescTV.setPlaceholder("Displayed on a List as a Preview")
        fullDescTV.setPlaceholder("Displayed in Full in a Details Page")
        
        for (index, textView) in textViews.enumerated() {
            textView.inputAccessoryView = toolbar
            textView.tag = index
            textView.delegate = self
        }
    }
    
    //Sets the Keyboard to push and lower the view when it appears and disappears
    private func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func setUpPickers() {
        datePicker.datePickerMode = .date
        dateTF.inputView = datePicker
        
        sTimePicker.datePickerMode = .time
        startTimeTF.inputView = sTimePicker
        
        eTimePicker.datePickerMode = .time
        endTimeTF.inputView = eTimePicker
        
    }
    
    func showImagePicker() {
        Utility.showImagePicker(imagePicker: imagePicker, viewController: self, completion: { (image) in
            if let image = image {
                self.imageIV.image = image
                self.imageChanged = true
            }
        })
    }
    
    func previousTextField() {
        Utility.previousTextField(runFirst: saveSelectedRow, activeTF: activeTextField, tfCollection: textFields, activeTV: activeTextView, tvCollection: textViews)
    }
    
    func nextTextField() {
        Utility.nextTextField(runFirst: saveSelectedRow, runLast: donePressed, activeTF: activeTextField, tfCollection: textFields, activeTV: activeTextView, tvCollection: textViews)
    }
    
    func donePressed() {
        Utility.donePressed(runFirst: saveSelectedRow, viewController: self)
    }
    
    func saveSelectedRow() {
        if activeTextField == dateTF {
            let date = datePicker.date
            dateTF.text = Utility.fbDateFormatter.string(from: date)
        }
        
        if activeTextField == startTimeTF {
            let time = sTimePicker.date
            startTimeTF.text = Utility.fbTimeFormatter.string(from: time)
            eTimePicker.minimumDate = sTimePicker.date
        }
        
        if activeTextField == endTimeTF {
            let time = eTimePicker.date
            endTimeTF.text = Utility.fbTimeFormatter.string(from: time)
            sTimePicker.maximumDate = eTimePicker.date
        }
    }
    
    fileprivate func updateButtonState() {
        let isAnyEmpty = textFields.reduce(false, { $0 || ($1.text?.isEmpty ?? true) }) || textViews.reduce(false, { $0 || ($1.text?.isEmpty ?? true) })
        createBtn.isEnabled = !isAnyEmpty
        createBtn.alpha = isAnyEmpty ? Config.disableAlpha : Config.enableAlpha
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        let startDateTime = Date.dateTime(forDate: datePicker.date, forTime: sTimePicker.date)
        let endDateTime = Date.dateTime(forDate: datePicker.date, forTime: eTimePicker.date)
        var image: UIImage? = nil
        
        if imageChanged, let img = imageIV.image {
            image = img
        }
        
        guard let name = nameTF.text, let venue = venueTF.text, let shortDesc = shortDescTV.text, let fullDesc = fullDescTV.text else {
            return
        }
        
        let event = Event(id: nil, image: image, name: name, startDateTime: startDateTime, endDateTime: endDateTime, venue: venue, shortDesc: shortDesc, description: fullDesc, comments: [Comment]())
        
        System.client.createEvent(event, completion: { (error) in
            Utility.popViewController(no: 1, viewController: self)
        })
    }
}

extension CreateEventViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nextTextField()
        updateButtonState()
        
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        activeTextField = nil
        updateButtonState()
    }
    
    func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeTextField = self.activeTextField {
            if (!aRect.contains(activeTextField.frame.origin)){
                self.scrollView.scrollRectToVisible(activeTextField.frame, animated: true)
            }
        } else if let activeTextView = self.activeTextView {
                if (!aRect.contains(activeTextView.frame.origin)){
                    self.scrollView.scrollRectToVisible(activeTextView.frame, animated: true)
                }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.isScrollEnabled = false
    }

}

extension CreateEventViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeTextView = textView
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        activeTextView = nil
        updateButtonState()
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
}

