//
//  Extensions.swift
//  SWSG
//
//  Created by shixiyue on 13/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

/**
 Extensions consists of extensions to various classes to perform additional
 functionality
 */
extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension NSCoder {
    func encodeUserTypes(_ type: UserTypes) {
        self.encode(type.isParticipant, forKey: Config.isParticipant)
        self.encode(type.isSpeaker, forKey: Config.isSpeaker)
        self.encode(type.isMentor, forKey: Config.isMentor)
        self.encode(type.isOrganizer, forKey: Config.isOrganizer)
        self.encode(type.isAdmin, forKey: Config.isAdmin)
    }
    
    func decodeUserTyes() -> UserTypes {
        let isParticipant = self.decodeBool(forKey: Config.isParticipant)
        let isSpeaker = self.decodeBool(forKey: Config.isSpeaker)
        let isMentor = self.decodeBool(forKey: Config.isMentor)
        let isOrganizer = self.decodeBool(forKey: Config.isOrganizer)
        let isAdmin = self.decodeBool(forKey: Config.isAdmin)
        return UserTypes(isParticipant: isParticipant, isSpeaker: isSpeaker,
                         isMentor: isMentor, isOrganizer: isOrganizer, isAdmin: isAdmin)
    }
}

extension Date {
    static func date(from dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        //formatter.timeZone = TimeZone.init(abbreviation: "UTC")
        formatter.dateFormat = "yyyy MM dd"
        
        guard let date = formatter.date(from: dateString) else {
            return Date()
        }
        
        return date
    }
    
    static func time(from timeString: String) -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "HH:mm"
        
        guard let date = formatter.date(from: timeString) else {
            return Date()
        }
        
        return date
    }
    
    static func toString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
       return formatter.string(from: date)
    }
    
    static func dateTime(forDate date: Date, forTime time: Date) -> Date {
        let calendar = Calendar.current
        
        var slotComponents = DateComponents()
        slotComponents.day = calendar.component(.day, from: date)
        slotComponents.month = calendar.component(.month, from: date)
        slotComponents.year = calendar.component(.year, from: date)
        slotComponents.hour = calendar.component(.hour, from: time)
        slotComponents.minute = calendar.component(.minute, from: time)
        
        guard let dateTime = calendar.date(from: slotComponents) else {
            return Date()
        }
        
        return dateTime
    }
    
    func add(minutes: Int) -> Date {
        let calendar = Calendar.current
        guard let newDate = calendar.date(byAdding: .minute, value: minutes, to: self) else {
            return Date()
        }
        
        return newDate
    }
    
    func add(days: Int) -> Date {
        let calendar = Calendar.current
        guard let newDate = calendar.date(byAdding: .day, value: days, to: self) else {
            return Date()
        }
        
        return newDate
    }
    
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
    
    func lessThan(interval: TimeInterval, from date: Date) -> Bool {
        let difference = self.timeIntervalSince(date)
        
        return difference < interval
    }
}

extension String {
    
    var isEmptyContent: Bool { return trim().isEmpty }
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func trimTrailingWhiteSpace() -> String {
        return self.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
    }
    
    func containsWhiteSpace() -> Bool {
        let range = self.rangeOfCharacter(from: .whitespacesAndNewlines)
        if let _ = range {
            return true
        } else {
            return false
        }
    }
    
}

/// Copy from https://medium.com/@aatish.rajkarnikar/how-to-make-a-custom-image-cropper-with-swift-3-c0ec8c9c7884#.g94umbx7o
extension UIImageView {
    
    func imageFrame() -> CGRect {
        let imageViewSize = frame.size
        guard let imageSize = image?.size else {
            return CGRect.zero
        }
        
        let imageRatio = imageSize.width / imageSize.height
        let imageViewRatio = imageViewSize.width / imageViewSize.height
        
        if imageRatio < imageViewRatio {
            let scaleFactor = imageViewSize.height / imageSize.height
            let width = imageSize.width * scaleFactor
            let topLeftX = (imageViewSize.width - width) * 0.5
            return CGRect(x: topLeftX, y: 0, width: width, height: imageViewSize.height)
        } else {
            let scalFactor = imageViewSize.width / imageSize.width
            let height = imageSize.height * scalFactor
            let topLeftY = (imageViewSize.height - height) * 0.5
            return CGRect(x: 0, y: topLeftY, width: imageViewSize.width, height: height)
        }
    }
    
}

// Code from: https://stackoverflow.com/questions/29726643/how-to-compress-of-reduce-the-size-of-an-image-before-uploading-to-parse-as-pffi
extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in PNG format
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the PNG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    var png: Data? { return UIImagePNGRepresentation(self) }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
    
    func cropToSquare() -> UIImage {
        guard size.height != size.width else {
            return self
        }
        
        let sideLength = size.height < size.width ? size.height : size.width
        let xOffset = (size.width - sideLength) / 2
        let yOffset = (size.height - sideLength) / 2
        let cropArea = CGRect(x: xOffset, y: yOffset, width: sideLength, height: sideLength)
        let croppedCGImage = cgImage?.cropping(to: cropArea)
        return UIImage(cgImage: croppedCGImage!, scale: 0, orientation: self.imageOrientation)
    }
    
    func cropSquareToCircle() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        let breadthRect = CGRect(origin: .zero, size: size)
        UIBezierPath(ovalIn: breadthRect).addClip()
        self.draw(in: breadthRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}
