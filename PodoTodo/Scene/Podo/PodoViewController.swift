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
        view.layer.borderColor = UIColor.fourthGrape.cgColor
        view.layer.borderWidth = 0.7
        view.layer.cornerRadius = 10
        return view
    }()
    let label = {
        let view = UILabel()
        view.text = "수집한 포도알"
        view.font = UIFont(name: Font.jamsilRegular.rawValue, size: 15)
        return view
    }()
    let underlineView = UIView()
    
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
        view.addSubview(label)
        view.addSubview(underlineView)
        underlineView.backgroundColor = .firstGrape
        navigationItem.title = "포도알 스티커"
    }
    
    override func setConstraints() {
        grape.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.6)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(grape.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        underlineView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(label)
            make.height.equalTo(4)
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
