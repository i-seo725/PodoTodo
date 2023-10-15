//
//  PodoViewModel.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/13.
//

import Foundation

class PodoViewModel {
    
    func checkTodo(date: Date) {
        
        let todo = TodoRepository.shared.fetchFilter(isTodo: true, date: date)
        
        for item in todo {
            if item.isDone == false {
                return
            }
        }
    }
    
}
