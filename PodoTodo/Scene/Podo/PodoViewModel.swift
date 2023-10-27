//
//  PodoViewModel.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/13.
//

import Foundation
import RealmSwift

class PodoViewModel {
    
    var podoList = GrapeRepository.shared.fetch()
    var currentPodo = GrapeRepository.shared.fetchCurrent().first
    var todayTodo = TodoRepository.shared.fetchFilterOneDay(date: Date())
    
    func firstPodo() {
        if podoList.isEmpty {
            GrapeRepository.shared.create(GrapeList(isCurrent: true, completeDate: nil, plusDate: nil, deleteDate: nil))
            currentPodo = GrapeRepository.shared.fetchCurrent().first
        }
    }
    
    func currentPodoCount() -> Int {
        guard let count = currentPodo?.fillCount else {
            return 0
        }
        
        return count
    }
    
    func setNewPodo() {
        let todayTodo = TodoRepository.shared.fetchFilterOneDay(date: Date())
        let validateIsDone = todayTodo.filter { $0.isDone == false }
        let date = Date().addingTimeInterval(-86400).dateToString().stringToDate()
        if currentPodoCount() == 10 && (todayTodo.count == 0 || validateIsDone.isEmpty) {
            if let currentPodo {
                GrapeRepository.shared.update(id: currentPodo._id, isCurrent: false, fillCount: 10, completeDate: date, plusDate: date, deleteDate: nil)
                GrapeRepository.shared.create(GrapeList(isCurrent: true, completeDate: nil, plusDate: nil, deleteDate: nil))
            }
            currentPodo = GrapeRepository.shared.fetchCurrent().first
        }
    }
    
    func updatePodo() {
        let count = currentPodoCount()
        var changeCount = count
        let today = Date().dateToString().stringToDate()
        let validateIsDone = todayTodo.filter { $0.isDone == false }
        
//        if count == 10 {
//            return
//        }
        
        guard let currentPodo else {
            return
        }
        
        
        if validateIsDone.isEmpty && todayTodo.count != 0 {
            if currentPodo.plusDate != today {
                changeCount += 1
                if changeCount > 10 || changeCount > count + 1 {
                    return
                }
                GrapeRepository.shared.update(id: currentPodo._id, isCurrent: true, fillCount: changeCount, completeDate: nil, plusDate: today, deleteDate: nil)
            }
        } else {
            if currentPodo.deleteDate != today && currentPodo.plusDate == today {
                changeCount -= 1
                if changeCount < 0 || changeCount < count - 1 {
                    return
                }
                GrapeRepository.shared.update(id: currentPodo._id, isCurrent: true, fillCount: changeCount, completeDate: nil, plusDate: nil, deleteDate: today)
            }
        }
        
        
        
        
        
//        if validateIsDone.isEmpty && todayTodo.count != 0 {
//            if currentPodo.editDate != today {
//                GrapeRepository.shared.update(id: currentPodo._id, isCurrent: true, fillCount: count + 1, completeDate: nil, editDate: today)
//            }
//        } else {
//            GrapeRepository.shared.update(id: currentPodo._id, isCurrent: true, fillCount: count, completeDate: nil, editDate: nil)
//        }
    }

}
