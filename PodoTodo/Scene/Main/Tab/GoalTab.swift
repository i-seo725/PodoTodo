////
////  GoalTab.swift
////  PodoTodo
////
////  Created by 이은서 on 2023/10/03.
////
//
//import UIKit
//import Tabman
//import SnapKit
//
//class GoalTab: UIViewController {
//
//    let mainView = TableView()
//    
//    override func loadView() {
//        view = mainView
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        editContents()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
////        mainView.tableView.reloadData()
//    }
//    
//    func editContents() {
//        mainView.handler = { tableView, text, id, date in
//            tableView.reloadData()
//            let vc = GoalAddViewController()
//            vc.textField.text = text
//            vc.table = tableView
//            vc.listID = id
//            vc.status = .edit
//            vc.dateTextField.text = date.dateToString()
//            
//            vc.modalPresentationStyle = .pageSheet
//            guard let sheet = vc.sheetPresentationController else { return }
//            if #available(iOS 16.0, *) {
//                sheet.detents = [.custom(resolver: { context in
//                    return 120
//                })]
//            } else {
//                sheet.detents = [.medium()]
//            }
//            self.present(vc, animated: true)
//        }
//    }
//}
