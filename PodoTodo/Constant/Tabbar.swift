//
//  Tabbar.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/09/30.
//

import UIKit

enum Tabbar {
    
    enum Main: String {
        case text = "Todo"
        
        static var image: UIImage {
            return UIImage(systemName: "checklist")!
        }
        static var vc: UIViewController {
            return TabViewController()
        }
    }
    
    enum Podo: String {
        
        case text = "Podo"
        
        static var image: UIImage {
            return UIImage(systemName: "circle.hexagongrid.circle.fill")!
        }
        
        static var vc: UIViewController {
            return PodoViewController()
        }
    }
}
