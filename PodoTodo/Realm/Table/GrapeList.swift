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
    @Persisted var fillCount: Int
    @Persisted var completeDate: Date?
    @Persisted var color: Grape
    
    convenience init(isCurrent: Bool, fillCount: Int = 0, completeDate: Date?, color: Grape = .purple) {
        self.init()
        self.isCurrent = isCurrent
        self.fillCount = fillCount
        self.completeDate = completeDate?.dateToString().stringToDate()
        self.color = color
    }
    
}
