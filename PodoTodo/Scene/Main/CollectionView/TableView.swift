//
//  CollectionView.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/09.
//

import UIKit
import SnapKit

class TableView: UIView {
    
    let tableView = UITableView()
    let viewModel = CollectionViewModel()
    var tab = KindOfTab.todo
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    func configureView() {
        backgroundColor = .white
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TableView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tab {
        case .todo: return viewModel.todoList.count
        case .goal: return viewModel.goalList.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var contents = cell.defaultContentConfiguration()
        
        switch tab {
        case .todo:
            contents.text = viewModel.todoList[indexPath.row].contents
        case .goal:
            contents.text = viewModel.goalList[indexPath.row].contents
            contents.secondaryText = "\(viewModel.goalList[indexPath.row].date)"
        }
        
        cell.contentConfiguration = contents
        
        return cell
    }
    
    
}
