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
        tableView.delegate = self
        tableView.dataSource = self
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

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var config = cell.defaultContentConfiguration()
        config.text = "알림 설정"
        cell.contentConfiguration = config
        return cell
    }
    
}
