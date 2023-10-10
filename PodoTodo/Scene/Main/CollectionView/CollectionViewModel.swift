//
//  CollectionViewModel.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/08.
//

import Foundation
import RealmSwift

class CollectionViewModel {
    
    let todoList = Repository.shared.fetchFilter(isTodo: true)
    let goalList = Repository.shared.fetchFilter(isTodo: false)

    func toggleTodo(indexPath: IndexPath) {
        if todoList[indexPath.row].isDone {
            Repository.shared.toggleDone(id: todoList[indexPath.row]._id, isDone: false)
        } else {
            Repository.shared.toggleDone(id: todoList[indexPath.row]._id, isDone: true)
        }
    }
    
    func toggleGoal(indexPath: IndexPath) {
        if goalList[indexPath.row].isDone {
            Repository.shared.toggleDone(id: goalList[indexPath.row]._id, isDone: false)
        } else {
            Repository.shared.toggleDone(id: goalList[indexPath.row]._id, isDone: true)
        }
    }
    
}
