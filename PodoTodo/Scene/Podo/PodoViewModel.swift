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
    var currentPodo = GrapeRepository.shared.fetchCurrent()
    
    func firstPodo() {
        if podoList.isEmpty {
            GrapeRepository.shared.create(GrapeList(isCurrent: true, completeDate: nil))
        }
    }
    
    func currentPodoCount() -> Int {
        guard let count = GrapeRepository.shared.fetchCurrent().first?.fillCount else {
            return 0
        }
        
        return count
    }
    
    func updatePodo(isCurrent: Bool, fillCount: Int, completeDate: Date?) {
        guard let id = currentPodo.first?._id else { return }
        
        GrapeRepository.shared.update(id: id, isCurrent: isCurrent, fillCount: fillCount, completeDate: completeDate)
    }
    
    func createPodo() {
        GrapeRepository.shared.create(GrapeList(isCurrent: true, completeDate: nil))
        currentPodo = GrapeRepository.shared.fetchCurrent()
    }
    
    func deletePodo() {
        if let data = GrapeRepository.shared.fetchTodayDone().first {
            
            let deleteData = GrapeRepository.shared.fetchCurrent()
            GrapeRepository.shared.delete(deleteData.first!)
//            GrapeRepository.shared.update(id: data.first._id, isCurrent: <#T##Bool#>, fillCount: <#T##Int#>, completeDate: <#T##Date?#>)
            
        }
    }
}
