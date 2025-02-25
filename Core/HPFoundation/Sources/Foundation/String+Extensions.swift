//
//  String+Extensions.swift
//  HPExtensions
//
//  Created by Kim dohyun on 2023/06/05.
//

import UIKit

public extension String {
    
    func stringToAttributed(_ font: UIFont,
                            _ color: UIColor) -> NSMutableAttributedString {
        
        let attributedString = NSMutableAttributedString(string: self)
        let range = (self as NSString).range(of: self)
        attributedString.addAttribute(.font, value: font, range: range)
        attributedString.addAttribute(.foregroundColor, value: color, range: range)
        
        return attributedString
    }
    
    func toPhoneNumber() -> String {
        let digits = digitsOnly
        if digits.count == 11 || digits.count < 13 {
            return digits.replacingOccurrences(of: "(\\d{3})(\\d{4})(\\d+)", with: "$1-$2-$3", options: .regularExpression, range: nil)
        } else {
            return self
        }
    }
    
    func isValidPhoneNumber() -> Bool {
        let regex = "^01[0-1, 7][0-9]{7,8}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
    }
    
    func birthdayToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        if let date = dateFormatter.date(from: self) {
            
            let newDateFormatter = DateFormatter()
            newDateFormatter.dateFormat = "yyyy년 MM월 dd일"
            let newDateString = newDateFormatter.string(from: date)
            return newDateString
        } else {
            return ""
        }
    }
    
    
    func birthdayDashSymbolToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        if let date = dateFormatter.date(from: self) {
            let newDateFormatter = DateFormatter()
            newDateFormatter.dateFormat = "yyyy-MM-dd"
            
            let newDateString = newDateFormatter.string(from: date)
            return newDateString
        } else {
            return ""
        }
    }
    
    
    func birthdayToDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        guard let newDate = dateFormatter.date(from: self) else { return Date() }
        return newDate
    }
    
    func heightForView(font: UIFont, width: CGFloat) -> CGFloat{
        let label: UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        label.font = font
        label.text = self

        label.sizeToFit()
        return label.frame.height
    }
    
}


public extension StringProtocol {
    
    var digitsOnly: String {
        return String(filter(("0"..."9").contains))
    }
    
}
