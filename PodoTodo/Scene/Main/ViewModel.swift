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
        formatter.dateFormat = "main_date".localized
        
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
    }
    
    func deleteTodo(item: MainList) {
        todoRepo.delete(item)
    }
    
    func countOfCalendarEvent(date: Date) -> Int {
        let dateArray: [Date] = todoRepo.fetch().map { $0.date }
        print(dateArray)
        if dateArray.contains(date){
            return 1
        } else {
            return 0
        }
    }
    
    func updateTodo(id: ObjectId, contents: String, date: Date, group: ObjectId) {
        todoRepo.update(id: id, contents: contents, date: date, group: group)
    }
    
    
    func numberOfSections(color: String?) -> Int {
        if groupRepo.fetch().count == 0 {
            groupRepo.create(GroupList(groupName: "default_group".localized, color: color, isDefault: true))
        }
        return groupRepo.fetch().count
    }
    
    func fetchGroup() -> Results<GroupList>? {
        return groupRepo.fetch()
    }
}
