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
    
    let viewModel = GroupManageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
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
        vc.groupDelegate = self
        
        presentSheetView(vc, height: 55)
    }
    
//    @objc func enterButtonTapped(_ sender: UITextField) {
//        guard let text = sender.text else { return }
//        if text.isEmpty {
//            let alert = UIAlertController(title: "그룹명은 비워둘 수 없습니다", message: "그룹명을 입력해주세요", preferredStyle: .alert)
//            let ok = UIAlertAction(title: "확인", style: .default)
//            alert.addAction(ok)
//            present(alert, animated: true)
//        } else if let selectedColor {
//            GroupRepository.shared.create(GroupList(groupName: text, color: selectedColor))
//            tableView.reloadData()
//        } else {
//            GroupRepository.shared.create(GroupList(groupName: text, color: "#9D76C1"))
//            tableView.reloadData()
//        }
//    }
}

extension GroupManagementViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.fetchGroup.count == 0 {
            return 1
        } else {
            return viewModel.fetchGroup.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = GroupTableViewCell()
        cell.selectionStyle = .none
        
        let groupList = viewModel.fetchGroup[indexPath.row]
        guard let color = groupList.color else { return cell }
        cell.colorView.backgroundColor = color.hexStringToUIColor()
        cell.groupNameLabel.text = groupList.groupName
         
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = viewModel.fetchGroup[indexPath.row]//._id
        
        if status == .edit {
            let vc = GroupAddViewController()
            vc.status = .edit
            vc.listID = group._id
            vc.groupDelegate = self
            vc.selectedColor = group.color
            presentSheetView(vc, height: 55)
            
        } else if status == .select {
            NotificationCenter.default.post(name: NSNotification.Name("groupID"), object: nil, userInfo: ["groupID": group._id])
            dismiss(animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let groupID = viewModel.fetchGroup[indexPath.row]._id
        
        if editingStyle == .delete {
            
            if groupID == viewModel.fetchDefault.first!._id {
                let alert = UIAlertController(title: "기본 그룹은 삭제할 수 없습니다", message: nil, preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default)
                alert.addAction(ok)
                present(alert, animated: true)
                return
            }
            if viewModel.fetchTodo(groupID: groupID).count != 0 {
                let alert = UIAlertController(title: "그룹을 삭제하시겠습니까?", message: "해당 그룹에 속한 모든 Todo가 함께 삭제됩니다", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "취소", style: .cancel)
                let ok = UIAlertAction(title: "확인", style: .destructive) { _ in
                    let deleteList = self.viewModel.fetchTodo(groupID: groupID)
                    for item in deleteList {
                        self.viewModel.deleteTodo(item)
                    }
                    self.viewModel.deleteGroup(self.viewModel.fetchGroup[indexPath.row])
                    tableView.reloadData()
                }
                alert.addAction(ok)
                alert.addAction(cancel)
                present(alert, animated: true)
            } else {
                viewModel.deleteGroup(viewModel.fetchGroup[indexPath.row])
                tableView.reloadData()
            }
        }
    }
    
}

extension GroupManagementViewController: GroupAddProtocol {
    
    func groupTableReload() {
        tableView.reloadData()
    }
    
}
