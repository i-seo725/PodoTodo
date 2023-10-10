//
//  String+Extension.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/09/29.
//

import Foundation

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
             formatter.dateFormat = "yyyy년 MM월 dd일, a h시 mm분"
             formatter.timeZone = TimeZone(identifier: "KST")
             if let date = formatter.date(from: self) {
                 return date
             } else {
                 return nil
             }
    }
    
}
