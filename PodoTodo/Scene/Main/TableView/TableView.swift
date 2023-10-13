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
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    let viewModel = ViewModel()
    var handler: ((_ table: UITableView, _ contents: String, _ id: ObjectId, _ date: Date) -> ())?
    var calendarDate = Date()
    var isOpen = [true]
    
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
        tableView.layer.cornerRadius = 15
        tableView.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TableView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = TableViewHeaderCell()
        view.delegate = self
        view.expandImage.image = isOpen[section] ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down")
        view.sectionIndex = section
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isOpen[section] {
            return viewModel.todoList(date: calendarDate).count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        var contents = cell.defaultContentConfiguration()
        contents.textProperties.font = UIFont(name: Font.jamsilLight.rawValue, size: 15)!
        
        let todoList = viewModel.todoList(date: calendarDate)[indexPath.row]
        if todoList.isDone == true {
            contents.attributedText = todoList.contents.strikeThrough()
        } else {
            contents.text = todoList.contents
        }
        
        cell.contentConfiguration = contents
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let todoList = viewModel.todoList(date: calendarDate)[indexPath.row]
        
        let text = todoList.contents
        let id = todoList._id
        handler?(tableView, text, id, Date())
       
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Repository.shared.delete(viewModel.todoList(date: calendarDate)[indexPath.row])
            tableView.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let doneButton = UIContextualAction(style: .normal, title: nil) { action, view, handler in
            
            self.viewModel.toggleTodo(date: self.calendarDate, indexPath: indexPath)
            self.tableView.reloadData()
            
            handler(true)
        }
        doneButton.backgroundColor = .thirdGrape
        doneButton.image = viewModel.todoList(date: calendarDate)[indexPath.row].isDone ? UIImage(systemName: "return")! : UIImage(systemName: "checkmark")!
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [doneButton])
        
        return swipeConfiguration
    }
    
    
}

extension TableView: SectionViewDelegate {
    
    func sectionViewTapped(_ section: Int) {
        isOpen[section].toggle()
        tableView.reloadData()
    }
    
}
