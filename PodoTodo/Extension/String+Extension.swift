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
    
    
}
