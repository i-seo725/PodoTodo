//
//  BaseViewController.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/09/29.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setConstraints()
    }
    
    func configureView() {
        view.backgroundColor = UIColor(rgb: Color.background.rawValue)
    }
    
    func setConstraints() { }
    
}
