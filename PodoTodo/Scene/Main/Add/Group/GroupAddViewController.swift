//
//  GroupAddViewController.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/12.
//

import UIKit

class GroupAddViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func setConstraints() {
        
    }
    
    func configureNavigationBar() {
        if let navBar = navigationController?.navigationBar {
            navBar.tintColor = .firstGrape
            navBar.backgroundColor = .white
            navBar.titleTextAttributes = [.font: UIFont(name: Font.jamsilRegular.rawValue, size: 18)]
        }
        title = "그룹 관리"
    }
}
