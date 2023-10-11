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
        NotificationCenter.default.addObserver(self, selector: #selector(receiveDate), name: NSNotification.Name("selectedDate"), object: nil)
    }
    
    @objc func receiveDate(notification: NSNotification) {
        guard let date = notification.userInfo?["date"] as? Date else {
            return
        }
        calendarDate = date
        viewModel.todoList(date: date)
        viewModel.goalList(date: date)
        tableView.reloadData()
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
        case .todo:
            print(viewModel.todoList(date: calendarDate).count, "todo")
            return viewModel.todoList(date: calendarDate).count
        case .goal:
            print(viewModel.goalList(date: calendarDate).count, "goal")
            return viewModel.goalList(date: calendarDate).count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var contents = cell.defaultContentConfiguration()
        
        if indexPath.row < viewModel.goalList(date: calendarDate).count {
            
            contents.textProperties.font = UIFont(name: Font.jamsilLight.rawValue, size: 16)!
            contents.secondaryTextProperties.font = UIFont(name: Font.jamsilThin.rawValue, size: 12)!
            
            let todoList = viewModel.todoList(date: calendarDate)[indexPath.row]
            let goalList = viewModel.goalList(date: calendarDate)[indexPath.row]
            
            switch tab {
            case .todo:
                
                if todoList.isDone == true {
                    contents.attributedText = todoList.contents.strikeThrough()
                } else {
                    contents.text = todoList.contents
                }
                
            case .goal:
                
                let dateText = "\(goalList.date)까지"
                if goalList.isDone == true {
                    contents.attributedText = goalList.contents.strikeThrough()
                    contents.secondaryAttributedText = dateText.strikeThrough()
                } else {
                    contents.text = goalList.contents
                    contents.secondaryText = dateText
                }
                
            }
            
            cell.contentConfiguration = contents
        } else {
            print(indexPath.row, "몇번재 로우")
            print(viewModel.goalList(date: calendarDate))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let todoList = viewModel.todoList(date: calendarDate)[indexPath.row]
        let goalList = viewModel.goalList(date: calendarDate)[indexPath.row]
        
        switch tab {
        case .todo:
            let text = todoList.contents
            let id = todoList._id
            handler?(tableView, text, id, Date())
        case .goal:
            let text = goalList.contents
            let date = goalList.date
            let id = goalList._id
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
                Repository.shared.delete(viewModel.todoList(date: calendarDate)[indexPath.row])
                tableView.reloadData()
            }
        case .goal:
            if editingStyle == .delete {
                Repository.shared.delete(viewModel.goalList(date: calendarDate)[indexPath.row])
                tableView.reloadData()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let doneButton = UIContextualAction(style: .normal, title: nil) { action, view, handler in
            
            switch self.tab {
            case .todo:
                self.viewModel.toggleTodo(date: self.calendarDate, indexPath: indexPath)
            case .goal:
                self.viewModel.toggleGoal(date: self.calendarDate, indexPath: indexPath)
            }
            self.tableView.reloadData()
            
            handler(true)
        }
        doneButton.backgroundColor = .thirdGrape
        
        switch tab {
        case .todo:
            doneButton.image = viewModel.todoList(date: calendarDate)[indexPath.row].isDone ? UIImage(systemName: "return")! : UIImage(systemName: "checkmark")!
        case .goal:
            doneButton.image = viewModel.goalList(date: calendarDate)[indexPath.row].isDone ? UIImage(systemName: "return")! : UIImage(systemName: "checkmark")!
        }
        
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [doneButton])
        
        
        return swipeConfiguration
    }
    
    
}
