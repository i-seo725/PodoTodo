////
////  CollectionView.swift
////  PodoTodo
////
////  Created by 이은서 on 2023/10/09.
////
//
//import UIKit
//import SnapKit
//import RealmSwift
//
//class TableView: UIView {
//
//    var handler: ((_ table: UITableView, _ contents: String, _ id: ObjectId, _ date: Date) -> ())?
//    var calendarDate = Date()
//    var isOpen = [true]
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        configureView()
//        NotificationCenter.default.addObserver(self, selector: #selector(receiveDate), name: NSNotification.Name("selectedDate"), object: nil)
//    }
//
//    @objc func receiveDate(notification: NSNotification) {
//        guard let date = notification.userInfo?["date"] as? Date else {
//            return
//        }
//        calendarDate = date
//        viewModel.todoList(date: date)
//        todoTable.reloadData()
//    }
//
//    func configureView() {
//        backgroundColor = .white
//        addSubview(todoTable)
//        todoTable.snp.makeConstraints { make in
//            make.size.equalToSuperview()
//        }
//
//        todoTable.backgroundColor = .white
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}
//
