//
//  SettingViewController.swift
//  PodoTodo
//
//  Created by 이은서 on 6/15/24.
//

import UIKit
import SnapKit

final class SettingViewController: BaseViewController {
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureView() {
        super.configureView()
        configNavBar()
        view.addSubview(tableView)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configNavBar() {
        navigationItem.title = "설정"
        navigationController?.navigationBar.tintColor = .firstGrape
    }
}
