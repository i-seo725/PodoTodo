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
    
    var numberOfRows = 1
    
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = settingTableView.dequeueReusableCell(withIdentifier: "cell") as? SettingTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        
        
        
        switch indexPath.row {
        case 0:
            cell.title.text = "알림 설정"
            cell.alertSwitch.isHidden = false
            cell.timePicker.isHidden = true
        case 1:
            cell.title.text = "알림 시간"
            cell.alertSwitch.isHidden = true
            cell.timePicker.isHidden = false
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
}
