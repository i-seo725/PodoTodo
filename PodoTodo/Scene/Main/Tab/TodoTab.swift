//
//  TodoTab.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/03.
//

import UIKit
import Tabman
import SnapKit

class TodoTab: UITabBarController {
    
    let label = {
        let view = UILabel()
        view.text = "여기는 투두 탭"
        view.font = UIFont(name: Font.jamsilBold.rawValue, size: 20)
        view.textColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
}
