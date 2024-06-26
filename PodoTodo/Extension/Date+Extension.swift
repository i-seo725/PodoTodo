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
        formatter.locale = .autoupdatingCurrent // Locale(identifier: "ko_KR")
//        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateFormat = "date_format".localized
        
        let result = formatter.string(from: self)
        return result
    }

    
}
