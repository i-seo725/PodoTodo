//
//  GroupManageViewModel.swift
//  PodoTodo
//
//  Created by 이은서 on 11/12/23.
//

import Foundation
import RealmSwift

final class GroupManageViewModel {
    
    private let groupRepo = GroupRepository()
    private let todoRepo = TodoRepository()
    
    var fetchGroup: Results<GroupList> {
        return groupRepo.fetch()
    }
    
    var fetchDefault: Results<GroupList> {
        return groupRepo.fetchDefault()
    }
    
    func deleteGroup(_ item: GroupList) {
        groupRepo.delete(item)
    }
    
    func fetchTodo(groupID: ObjectId) -> Results<MainList> {
        return todoRepo.fetchGroup(group: groupID)
    }
    
    func deleteTodo(_ item: MainList) {
        todoRepo.delete(item)
    }
    
}
