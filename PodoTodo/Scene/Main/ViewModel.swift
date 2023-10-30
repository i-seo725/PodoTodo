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
    
    func configureNavigationTitle(_ date: Date) -> String {

        let formatter = DateFormatter()
        formatter.locale = .autoupdatingCurrent
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateFormat = "yyyy년 MM월"
        
        let result = formatter.string(from: date)
        return result
    }
    
    
    func allTodoList(date: Date) -> Results<MainList>? {
        return TodoRepository.shared.fetchFilterOneDay(date: date)
    }
    
    func todoList(date: Date, groupID: ObjectId) -> Results<MainList>? {
        return TodoRepository.shared.fetchFilter(isTodo: true, date: date, group: groupID)
    }
    
    func goalList(date: Date, groupID: ObjectId) -> Results<MainList>? {
        return TodoRepository.shared.fetchFilter(isTodo: false, date: date, group: groupID)
    }
    
    func toggleTodo(date: Date, indexPath: IndexPath, groupID: ObjectId) {
        guard let todoList = todoList(date: date, groupID: groupID)?[indexPath.row] else { return }
        if todoList.isDone {
            TodoRepository.shared.toggleDone(id: todoList._id, isDone: false)
        } else {
            TodoRepository.shared.toggleDone(id: todoList._id, isDone: true)
        }
    }
    
    func laterTodo(date: Date, indexPath: IndexPath) {
        
    }
}
