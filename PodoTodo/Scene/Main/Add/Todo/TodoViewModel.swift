//
//  TodoViewModel.swift
//  PodoTodo
//
//  Created by 이은서 on 11/11/23.
//

import Foundation
import RealmSwift

final class TodoViewModel {
    
    private let todoRepo = TodoRepository()
    private let groupRepo = GroupRepository()
    
    var defaultGroup: Results<GroupList> {
        return groupRepo.fetchDefault()
    }
    
    func fetchGroup(id: ObjectId) -> Results<GroupList> {
        return groupRepo.fetchFilter(id: id)
    }
    
    func fetchSpecificTodo(id: ObjectId) -> Results<MainList> {
        return todoRepo.fetchFilterWithID(id: id)
    }
    
    func createTodo(_ item: MainList) {
        todoRepo.create(item)
    }
    
    func updateTodo(id: ObjectId, contents: String, date: Date, group: ObjectId) {
        todoRepo.update(id: id, contents: contents, date: date, group: group)
    }
    
}
