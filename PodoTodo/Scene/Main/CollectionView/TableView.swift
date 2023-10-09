//
//  CollectionView.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/09.
//

import UIKit
import SnapKit
import RealmSwift

class TableView: UIView {
    
    let tableView = UITableView()
    let viewModel = CollectionViewModel()
    var tab = KindOfTab.todo
    var handler: ((UITableView, String, ObjectId, Date?) -> ())?
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tab {
        case .todo:
            let text = viewModel.todoList[indexPath.row].contents
            let id = viewModel.todoList[indexPath.row]._id
            handler?(tableView, text, id, nil)
        case .goal:
            let text = viewModel.goalList[indexPath.row].contents
            let date = viewModel.goalList[indexPath.row].date
            let id = viewModel.goalList[indexPath.row]._id
            handler?(tableView, text, id, date)
        }
    }
    
}
