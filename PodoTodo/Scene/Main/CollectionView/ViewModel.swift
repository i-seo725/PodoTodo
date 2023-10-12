//
//  CollectionViewModel.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/08.
//

import Foundation
import RealmSwift

class ViewModel {

//    let todoList = Repository.shared.fetchFilter1(isTodo: true)
//    let goalList = Repository.shared.fetchFilter1(isTodo: false)
    
    func todoList(date: Date) -> Results<MainList> {
        return Repository.shared.fetchFilter(isTodo: true, date: date)
    }
    
    func goalList(date: Date) -> Results<MainList> {
        return Repository.shared.fetchFilter(isTodo: false, date: date)
    }
    
    
    
    
//    func toggleTodo(indexPath: IndexPath) {
//        let todoList = todoList[indexPath.row]
//        if todoList.isDone {
//            Repository.shared.toggleDone(id: todoList._id, isDone: false)
//        } else {
//            Repository.shared.toggleDone(id: todoList._id, isDone: true)
//        }
//    }
//
//    func toggleGoal(indexPath: IndexPath) {
//        let goalList = goalList[indexPath.row]
//        if goalList.isDone {
//            Repository.shared.toggleDone(id: goalList._id, isDone: false)
//        } else {
//            Repository.shared.toggleDone(id: goalList._id, isDone: true)
//        }
//    }
    
    func toggleTodo(date: Date, indexPath: IndexPath) {
        let todoList = todoList(date: date)[indexPath.row]
        if todoList.isDone {
            Repository.shared.toggleDone(id: todoList._id, isDone: false)
        } else {
            Repository.shared.toggleDone(id: todoList._id, isDone: true)
        }
    }
}
