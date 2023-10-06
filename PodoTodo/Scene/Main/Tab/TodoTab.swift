//
//  TodoTab.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/03.
//

import UIKit
import Tabman
import SnapKit

class TodoTab: UIViewController {
 
    override func loadView() {
        view = ListCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(rgb: Color.background.rawValue)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("todo tab")
        NotificationCenter.default.post(name: NSNotification.Name("todo"), object: nil, userInfo: ["tab": KindOfTab.todo])
    }
    
}
