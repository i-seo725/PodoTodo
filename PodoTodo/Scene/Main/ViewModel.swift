//
//  CollectionViewModel.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/08.
//

import Foundation
import RealmSwift

final class MainViewModel {

    private let todoRepo = TodoRepository()
    private let groupRepo = GroupRepository()
    
    func configureNavigationTitle(_ date: Date) -> String {

        let formatter = DateFormatter()
        formatter.locale = .autoupdatingCurrent
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateFormat = "yyyy년 MM월"
        
        let result = formatter.string(from: date)
        return result
    }
    
    func allTodoList(date: Date) -> Results<MainList>? {
        return todoRepo.fetchFilterOneDay(date: date)
    }
    
    func todoList(date: Date, groupID: ObjectId) -> Results<MainList>? {
        return todoRepo.fetchFilter(isTodo: true, date: date, group: groupID)
    }
    
    func toggleTodo(date: Date, indexPath: IndexPath, groupID: ObjectId) {
        
        guard let todoList = todoList(date: date, groupID: groupID)?[indexPath.row] else { return }
        todoRepo.toggleDone(id: todoList._id, isDone: !todoList.isDone)
//        if todoList.isDone {
//            todoRepo.toggleDone(id: todoList._id, isDone: false)
//        } else {
//            todoRepo.toggleDone(id: todoList._id, isDone: true)
//        }
    }
    
    func deleteTodo(item: MainList) {
        todoRepo.delete(item)
    }
    
    func countOfCalendarEvent(date: Date) -> Int {
        let dateArray = todoRepo.fetch().map { $0.date }
        
        if dateArray.contains(date){
            return 1
        } else {
            return 0
        }
    }
    
    
    func numberOfSections(color: String?) -> Int {
        if groupRepo.fetch().count == 0 {
            groupRepo.create(GroupList(groupName: "기본 그룹", color: color, isDefault: true))
        }
        return groupRepo.fetch().count
    }
    
    func fetchGroup() -> Results<GroupList>? {
        return groupRepo.fetch()
    }
}
