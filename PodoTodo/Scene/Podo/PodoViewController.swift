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
        view.backgroundColor = .white
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
    lazy var podoCollection = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    var savedPodo = UserDefaults.standard.integer(forKey: "podo")
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        if let size = view.window?.windowScene?.screen.bounds.width {
            layout.itemSize = .init(width: (size - 56) / 5, height: (size - 56) / 5)
            layout.minimumLineSpacing = 8
            print("@@")
            return layout
        } else {
            layout.itemSize = CGSize(width: 40, height: 40)
            layout.minimumLineSpacing = 8
            print("!!")
            return layout
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(savedPodo)
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
        view.addSubview(podoCollection)
        podoCollection.backgroundColor = .fourthGrape
        underlineView.backgroundColor = .firstGrape
        navigationItem.title = "포도알 스티커"
        if let navBar = navigationController?.navigationBar {
            navBar.titleTextAttributes = [.font: UIFont(name: Font.jamsilRegular.rawValue, size: 16)!]
            navBar.backgroundColor = .background
        }
    }
    
    override func setConstraints() {
        grape.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
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
        
        podoCollection.snp.makeConstraints { make in
            make.top.equalTo(underlineView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(grape)
            make.bottom.equalToSuperview()
        }
    }
    
    func fillPodo() {
        let todo = TodoRepository.shared.fetchFilterOneDay(date: Date())
        let validate: [MainList] = todo.filter { $0.isDone == false }
        let grapeArray = Grape.Purple.allCases
        var podo = savedPodo
        
        guard validate.isEmpty && todo.count != 0 else {
            podo = savedPodo
            grape.image = UIImage(named: grapeArray[podo].rawValue)!
            return
        }
        
        podo = savedPodo + 1
        if podo > 10 {
            UserDefaults.standard.set(0, forKey: "podo")
            podo = 0
        } else {
            UserDefaults.standard.set(podo, forKey: "podo")
//            savedPodo = UserDefaults.standard.integer(forKey: "podo")
        }
        grape.image = UIImage(named: grapeArray[podo].rawValue)!
    }
    
}
