//
//  PodoViewModel.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/13.
//

import Foundation
import RealmSwift

final class PodoViewModel {
    
    private let podoRepo = GrapeRepository()
    private let todoRepo = TodoRepository()
    
    lazy var podoList = podoRepo.fetch()
    lazy var currentPodo = podoRepo.fetchCurrent().first
    
    /*
    var podoList: Results<GrapeList> {
        get {
            return podoRepo.fetch()
        }
        set {
            self.podoList = newValue
        }
    }
    
    var currentPodo: GrapeList? {
        get {
            return podoRepo.fetchCurrent().first
        }
        set {
            self.currentPodo = newValue
        }
    }
    */
    var todayTodo: Results<MainList>? {
        return todoRepo.fetchFilterOneDay(date: Date())
    }
    
    func firstPodo() {
        if podoList.isEmpty {
            podoRepo.create(GrapeList(isCurrent: true, completeDate: nil, plusDate: nil, deleteDate: nil))
            currentPodo = podoRepo.fetchCurrent().first
        }
    }
    
    func currentPodoCount() -> Int {
        guard let count = currentPodo?.fillCount else {
            return 0
        }
        
        return count
    }
    
    func setNewPodo() {
        guard let todayTodo else { return }
        let validateIsDone = todayTodo.filter { $0.isDone == false }
        let date = Date().addingTimeInterval(-86400).dateToString().stringToDate()
        if currentPodoCount() == 10 && (todayTodo.count == 0 || validateIsDone.isEmpty) {
            if let currentPodo {
                podoRepo.update(id: currentPodo._id, isCurrent: false, fillCount: 10, completeDate: date, plusDate: date, deleteDate: nil)
                podoRepo.create(GrapeList(isCurrent: true, completeDate: nil, plusDate: nil, deleteDate: nil))
            }
            currentPodo = podoRepo.fetchCurrent().first
            podoList = podoRepo.fetch()
        }
    }
    
    func updatePodo() {
        guard let todayTodo else { return }
        let count = currentPodoCount()
        var changeCount = count
        let today = Date().dateToString().stringToDate()
        let validateIsDone = todayTodo.filter { $0.isDone == false }
        
        guard let currentPodo else {
            return
        }
        
        
        if validateIsDone.isEmpty && todayTodo.count != 0 {
            if currentPodo.plusDate != today {
                changeCount += 1
                if changeCount > 10 || changeCount > count + 1 {
                    return
                }
                podoRepo.update(id: currentPodo._id, isCurrent: true, fillCount: changeCount, completeDate: nil, plusDate: today, deleteDate: nil)
            }
        } else {
            if currentPodo.deleteDate != today && currentPodo.plusDate == today {
                changeCount -= 1
                if changeCount < 0 || changeCount < count - 1 {
                    return
                }
                podoRepo.update(id: currentPodo._id, isCurrent: true, fillCount: changeCount, completeDate: nil, plusDate: nil, deleteDate: today)
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
