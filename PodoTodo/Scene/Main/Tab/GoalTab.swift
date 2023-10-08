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

    let mainView = ListCollectionView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("goal"), object: nil, userInfo: ["tab": KindOfTab.goal])
        mainView.tap = .goal
        mainView.updateSnapshot()
    }
}
