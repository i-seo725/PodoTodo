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
            navBar.titleTextAttributes = [.font: UIFont(name: Font.jamsilRegular.rawValue, size: 18)]
        }
        
        title = "그룹 관리"
        
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTapped))
        navigationItem.rightBarButtonItem = plusButton
    }
    
    @objc func plusButtonTapped() {
        let vc = GroupAddViewController()
        vc.modalPresentationStyle = .pageSheet
        guard let sheet = vc.sheetPresentationController else { return }
        if #available(iOS 16.0, *) {
            sheet.detents = [.custom(resolver: { context in
                return 60
            })]
        } else {
            sheet.detents = [.medium()]
        }
        vc.table = tableView
        vc.status = .add
        
        present(vc, animated: true)
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
        
        if GroupRepository.shared.fetch().count == 0 {
            cell.colorView.backgroundColor = .thirdGrape
            cell.groupNameLabel.text = "기본 그룹"
            GroupRepository.shared.create(GroupList(groupName: "기본 그룹", color: UIColor.thirdGrape.hexString!))
            return cell
        }
        
        let groupList = GroupRepository.shared.fetch()[indexPath.row]
        guard let color = groupList.color else { return cell }
        cell.colorView.backgroundColor = color.hexStringToUIColor()
        cell.groupNameLabel.text = groupList.groupName
         
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if status == .edit {
            let vc = GroupAddViewController()
            vc.modalPresentationStyle = .pageSheet
            guard let sheet = vc.sheetPresentationController else { return }
            if #available(iOS 16.0, *) {
                sheet.detents = [.custom(resolver: { context in
                    return 60
                })]
            } else {
                sheet.detents = [.medium()]
            }
            vc.table = tableView
            vc.status = .edit
            vc.listID = GroupRepository.shared.fetch()[indexPath.row]._id
            
            present(vc, animated: true)
            
        } else if status == .select {
            dismiss(animated: true)
        }
        
        
    }
    
}
