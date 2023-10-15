//
//  ListTable.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/07.
//

import Foundation
import RealmSwift

class MainList: Object {
    
    override func isEqual(_ object: Any?) -> Bool {
        return true
    }
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var isTodo: Bool
    @Persisted var contents: String
    @Persisted var group: String
    @Persisted var date: Date
    @Persisted var checklist: String?
    @Persisted var isDone: Bool
    @Persisted var isAlert: Bool
    
    convenience init(isTodo: Bool, contents: String, isDone: Bool = false, isAlert: Bool = false, date: Date = Date()) {
        self.init()
        self.isTodo = isTodo
        self.contents = contents
        self.isDone = isDone
        self.isAlert = isAlert
        
        
        self.date = date.dateToString().stringToDate() ?? Date()
        
        
    }
    
}
