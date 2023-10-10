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
    var handler: ((_ table: UITableView, _ contents: String, _ id: ObjectId, _ date: Date) -> ())?
    var calendarDate = Date()
    
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
        
        contents.textProperties.font = UIFont(name: Font.jamsilLight.rawValue, size: 16)!
        contents.secondaryTextProperties.font = UIFont(name: Font.jamsilThin.rawValue, size: 12)!
        
        switch tab {
        case .todo:
            if viewModel.todoList[indexPath.row].isDone == true {
                contents.attributedText = viewModel.todoList[indexPath.row].contents.strikeThrough()
            } else {
                contents.text = viewModel.todoList[indexPath.row].contents
            }
        case .goal:
            let dateText = "\(viewModel.goalList[indexPath.row].date.dateToString())까지"
            if viewModel.goalList[indexPath.row].isDone == true {
                contents.attributedText = viewModel.goalList[indexPath.row].contents.strikeThrough()
                contents.secondaryAttributedText = dateText.strikeThrough()
            } else {
                contents.text = viewModel.goalList[indexPath.row].contents
                contents.secondaryText = dateText
            }
            
        }
        
        cell.contentConfiguration = contents
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tab {
        case .todo:
            let text = viewModel.todoList[indexPath.row].contents
            let id = viewModel.todoList[indexPath.row]._id
            handler?(tableView, text, id, Date())
        case .goal:
            let text = viewModel.goalList[indexPath.row].contents
            let date = viewModel.goalList[indexPath.row].date
            let id = viewModel.goalList[indexPath.row]._id
            handler?(tableView, text, id, date)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tab {
        case .todo:
            return 50
        case .goal:
            return 65
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        switch tab {
        case .todo:
            if editingStyle == .delete {
                Repository.shared.delete(viewModel.todoList[indexPath.row])
                tableView.reloadData()
            }
        case .goal:
            print(viewModel.goalList[indexPath.row])
            if editingStyle == .delete {
                Repository.shared.delete(viewModel.goalList[indexPath.row])
                tableView.reloadData()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneButton = UIContextualAction(style: .normal, title: nil) { action, view, handler in
                        
            switch self.tab {
            case .todo:
                self.viewModel.toggleTodo(indexPath: indexPath)
            case .goal:
                self.viewModel.toggleGoal(indexPath: indexPath)
            }
            self.tableView.reloadData()
            
            handler(true)
        }
        doneButton.backgroundColor = .thirdGrape
        doneButton.image = UIImage(systemName: "checkmark")!
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [doneButton])
        
        
        return swipeConfiguration
    }
    
    
}
