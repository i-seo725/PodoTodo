//
//  SettingViewController.swift
//  PodoTodo
//
//  Created by 이은서 on 6/15/24.
//

import UIKit
import SnapKit

final class SettingViewController: BaseViewController {
    
    let settingTableView = UITableView(frame: .zero, style: .insetGrouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureView() {
        super.configureView()
        configNavBar()
        view.addSubview(settingTableView)
        configureTableView()
    }
    
    override func setConstraints() {
        settingTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configNavBar() {
        navigationItem.title = "설정"
        navigationController?.navigationBar.tintColor = .firstGrape
    }
    
    func configureTableView() {
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.register(SettingTableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =
        return cell
    }
    
}
