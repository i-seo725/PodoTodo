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
    
    let label = {
        let view = UILabel()
        view.text = "@@@@@이건 목표야@@@"
        view.font = UIFont(name: Font.jamsilBold.rawValue, size: 20)
        view.textColor = .black
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(rgb: Color.background.rawValue)
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
}
