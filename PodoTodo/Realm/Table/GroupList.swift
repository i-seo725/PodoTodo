//
//  Group.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/09.
//

import Foundation
import RealmSwift

class GroupList: Object {

    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var groupName: String
    @Persisted var color: String?
    @Persisted var isOpen: Bool = true
    @Persisted var isDefault: Bool = false

    convenience init(groupName: String, color: String?, isDefault: Bool = false) {
        self.init()
        self.groupName = groupName
        self.color = color
        self.isDefault = isDefault
    }
}
