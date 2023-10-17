//
//  GrapeList.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/17.
//

import Foundation
import RealmSwift

class GrapeList: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var isCurrent: Bool
    @Persisted var fillCount: Int?
    @Persisted var completeDate: Date?
    @Persisted var color: String
    
    convenience init(isCurrent: Bool, fillCount: Int?, completeDate: Date?, color: String) {
        self.init()
        self.isCurrent = isCurrent
        self.fillCount = fillCount
        self.completeDate = completeDate
        self.color = color
    }
    
}
