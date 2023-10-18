//
//  GroupAddViewController.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/12.
//

import UIKit
import RealmSwift

class GroupManagementViewController: BaseViewController {
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    var status = Present.edit
    var selectedColor: String? = nil
    var handler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        handler?()
    }
    
    override func configureView() {
        super.configureView()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureNavigationBar() {
        if let navBar = navigationController?.navigationBar {
            navBar.tintColor = .firstGrape
            navBar.backgroundColor = .clear
            navBar.titleTextAttributes = [.font: UIFont.jamsilNav]
        }
        
        title = "그룹 관리"
        
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTapped))
        navigationItem.rightBarButtonItem = plusButton
    }
    
    @objc func plusButtonTapped() {
        let vc = GroupAddViewController()
        vc.status = .add
        vc.handler? = {
            self.tableView.reloadData()
        }
        presentSheetView(vc, height: 55)
    }
    
    @objc func enterButtonTapped(_ sender: UITextField) {
        guard let text = sender.text else { return }
        if text.isEmpty {
            let alert = UIAlertController(title: "주의", message: "그룹명은 비워둘 수 없습니다", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default) { _ in
                sender.becomeFirstResponder()
            }
            alert.addAction(ok)
            present(alert, animated: true)
        } else if let selectedColor {
            GroupRepository.shared.create(GroupList(groupName: text, color: selectedColor))
            tableView.reloadData()
        } else {
            GroupRepository.shared.create(GroupList(groupName: text, color: "#9D76C1"))
            tableView.reloadData()
        }
    }
}

extension GroupManagementViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if GroupRepository.shared.fetch().count == 0 {
            return 1
        } else {
            return GroupRepository.shared.fetch().count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = GroupTableViewCell()
        cell.selectionStyle = .none
        
        let groupList = GroupRepository.shared.fetch()[indexPath.row]
        guard let color = groupList.color else { return cell }
        cell.colorView.backgroundColor = color.hexStringToUIColor()
        cell.groupNameLabel.text = groupList.groupName
         
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let groupID = GroupRepository.shared.fetch()[indexPath.row]._id
        
        if status == .edit {
            let vc = GroupAddViewController()
            vc.status = .edit
            vc.listID = groupID
            vc.handler? = {
                tableView.reloadData()
            }
           
            presentSheetView(vc, height: 55)
            
        } else if status == .select {
            NotificationCenter.default.post(name: NSNotification.Name("groupID"), object: nil, userInfo: ["groupID": groupID])
            dismiss(animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let groupID = GroupRepository.shared.fetch()[indexPath.row]._id
        
        if editingStyle == .delete {
            
            if TodoRepository.shared.fetchGroup(group: groupID).count != 0 {
                let alert = UIAlertController(title: "주의", message: "해당 그룹에 등록된 투두가 있어 그룹을 삭제할 수 없습니다", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default)
                alert.addAction(ok)
                present(alert, animated: true)
            } else {
                GroupRepository.shared.delete(GroupRepository.shared.fetch()[indexPath.row])
                tableView.reloadData()
            }
        }
    }
    
}
