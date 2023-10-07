//
//  GoalTab.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/03.
//

import UIKit
import Tabman
import SnapKit

class GoalTab: UIViewController {

    override func loadView() {
        view = ListCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("goal tab")
        NotificationCenter.default.post(name: NSNotification.Name("goal"), object: nil, userInfo: ["tab": KindOfTab.goal])
    }
    
}
