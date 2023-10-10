//
//  Date+Extension.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/10.
//

import Foundation

extension Date {
    
    func dateToString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateFormat = "yyyy년 MM월 dd일"
        
        let result = formatter.string(from: self)
        return result
    }
    
}
