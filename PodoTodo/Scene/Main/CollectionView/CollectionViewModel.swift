//
//  CollectionViewModel.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/08.
//

import Foundation
import RealmSwift

class CollectionViewModel {
    
    let todoList = Repository.shared.fetchFilter(isTodo: true)//.toArray()
    let goalList = Repository.shared.fetchFilter(isTodo: false)//.toArray()
    
    
}
