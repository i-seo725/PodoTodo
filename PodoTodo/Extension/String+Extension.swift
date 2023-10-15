//
//  String+Extension.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/09/29.
//

import Foundation
import UIKit

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(text: String) -> String {
        return String(format: self.localized, text)
    }
    
    func localized(num: Int) -> String {
        return String(format: self.localized, num)
    }
    
    func stringToDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
//        formatter.timeStyle = .none
        if let date = formatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    
    func strikeThrough() -> NSAttributedString {
        let attribute = NSMutableAttributedString(string: self)
        attribute.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attribute.length))
        attribute.addAttribute(.foregroundColor, value: UIColor.lightGray, range: NSMakeRange(0, attribute.length))
        return attribute
    }
    
    func hexStringToUIColor() -> UIColor {
        var cString: String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
