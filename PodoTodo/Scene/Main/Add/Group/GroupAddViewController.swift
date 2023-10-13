//
//  GroupAddViewController.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/12.
//

import UIKit

class GroupAddViewController: BaseViewController {
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    var cellCount: Int = 1
    var status = Present.add
    
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
        status = .add
        cellCount += 1
        tableView.reloadData()
    }
}

extension GroupAddViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = GroupTableViewCell()
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
}
