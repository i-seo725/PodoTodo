//
//  PodoViewController.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/09/30.
//

import UIKit
import Tabman
import Pageboy

class PodoViewController: BaseViewController {
    
    let grape = {
        let view = UIImageView()
        view.image = UIImage(named: Grape.Purple.empty.rawValue)!
        view.contentMode = .scaleAspectFit
        return view
    }()
    var podo = 11
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fillPodo()
    }
    
    override func configureView() {
        super.configureView()
        view.addSubview(grape)
    }
    
    override func setConstraints() {
        grape.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.6)
        }
    }
    
    func fillPodo() {
        let todo = TodoRepository.shared.fetchFilterOneDay(date: Date())
        let validate: [MainList] = todo.filter { $0.isDone == false }
        let grapeArray = Grape.Purple.allCases
        
        if validate.isEmpty {
            if podo > 10 {
                podo = 0
            } else {
                podo += 1
                grape.image = UIImage(named: grapeArray[podo].rawValue)!
            }
        } else {
            if podo < 1 {
                return
            } else {
                podo -= 1
                grape.image = UIImage(named: grapeArray[podo].rawValue)!
            }
        }
    }
    
}
