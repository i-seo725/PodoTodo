//
//  Grape.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/04.
//

import UIKit
import RealmSwift

enum Grape {
    
    enum Purple: String, CaseIterable {
        case empty
        case one = "purple_1"
        case two = "purple_2"
        case three = "purple_3"
        case four = "purple_4"
        case five = "purple_5"
        case six = "purple_6"
        case seven = "purple_7"
        case eight = "purple_8"
        case nine = "purple_9"
//        case ten = "purple_10"
        case complete = "purple_complete"
    }
    
    enum Green: String {
        case empty
        case one = "green_1"
        case two = "green_2"
        case three = "green_3"
        case four = "green_4"
        case five = "green_5"
        case six = "green_6"
        case seven = "green_7"
        case eight = "green_8"
        case nine = "green_9"
//        case ten = "green_10"
        case complete = "green_complete"
    }
}
