//
//  GroupViewModel.swift
//  PodoTodo
//
//  Created by 이은서 on 11/10/23.
//

import Foundation
import RealmSwift


final class GroupViewModel {
    
    private let groupRepo = GroupRepository()
    
    func filterGroup(id: ObjectId) -> Results<GroupList> {
        groupRepo.fetchFilter(id: id)
    }
    
    func createGroup(item: GroupList) {
        groupRepo.create(item)
    }
    
    func updateGroup(id: ObjectId, name: String, color: String?) {
        groupRepo.update(id: id, groupName: name, color: color)
    }
    
}
