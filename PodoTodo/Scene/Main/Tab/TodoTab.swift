////
////  TodoTab.swift
////  PodoTodo
////
////  Created by 이은서 on 2023/10/03.
////
//
//import UIKit
//import Tabman
//import SnapKit
//
//class TodoTab: UIViewController {
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
//    func editContents() {
//        mainView.handler = { tableView, text, id, _ in
//            tableView.reloadData()
//            let vc = TodoAddViewController()
//            vc.textField.text = text
//            vc.status = .edit
//            vc.listID = id
//            vc.table = tableView
//            vc.modalPresentationStyle = .pageSheet
//            guard let sheet = vc.sheetPresentationController else { return }
//            if #available(iOS 16.0, *) {
//                sheet.detents = [.custom(resolver: { context in
//                    return 60
//                })]
//            } else {
//                sheet.detents = [.medium()]
//            }
//            self.present(vc, animated: true)
//        }
//    }
//    
//}
