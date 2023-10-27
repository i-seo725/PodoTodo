//
//  PodoViewController.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/09/30.
//

import UIKit
import RealmSwift

class PodoViewController: BaseViewController {
    
//    var grapeList = GrapeRepository.shared.fetch()
    var grapeArray = Grape.Purple.allCases
    let grape = {
        let view = UIImageView()
        view.image = UIImage(named: Grape.Purple.empty.rawValue)!
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .clear
        return view
    }()
    let label = {
        let view = UILabel()
        view.text = "수집한 포도알"
        view.font = UIFont.jamsilTitle
        return view
    }()
    let underlineView = UIView()
    lazy var podoCollection = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    let viewModel = PodoViewModel()
    func collectionViewLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewFlowLayout()
        let size = (UIScreen.main.bounds.width - 42) / 5
        layout.itemSize = CGSize(width: size, height: size)
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 8, left: 4, bottom: 4, right: 6)
        return layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.firstPodo()
        viewModel.setNewPodo()

    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updatePodo()
        grape.image = UIImage(named: grapeArray[viewModel.currentPodoCount()].rawValue)!
    }
    
    override func configureView() {
        super.configureView()
        addSubViews()
        configureColelctionView()
        underlineView.backgroundColor = .firstGrape
        navigationItem.title = "포도알 스티커"
        if let navBar = navigationController?.navigationBar {
            navBar.titleTextAttributes = [.font: UIFont.jamsilNav]
            navBar.backgroundColor = .background
        }
        
    }
    
    func addSubViews() {
        view.addSubview(grape)
        view.addSubview(label)
        view.addSubview(underlineView)
        view.addSubview(podoCollection)
    }
    
    func configureColelctionView() {
        podoCollection.backgroundColor = .white
        podoCollection.layer.cornerRadius = 20
        podoCollection.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.3).cgColor
        podoCollection.layer.borderWidth = 0.7
        podoCollection.delegate = self
        podoCollection.dataSource = self
        podoCollection.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.3).cgColor
        podoCollection.layer.borderWidth = 0.7
        podoCollection.register(PodoCollectionViewCell.self, forCellWithReuseIdentifier: "podoCell")
    }
    
    override func setConstraints() {
        grape.snp.makeConstraints { make in
            make.centerX.equalToSuperview().multipliedBy(0.9)
            make.top.equalTo(view.safeAreaLayoutGuide)//.offset(4)
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.6)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(grape.snp.bottom)//.offset(10)
            make.centerX.equalToSuperview()
        }
        
        underlineView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(label)
            make.height.equalTo(4)
        }
        
        podoCollection.snp.makeConstraints { make in
            make.top.equalTo(underlineView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(170)
        }
    }
    
//    func fillPodo() {
//        let todo = TodoRepository.shared.fetchFilterOneDay(date: Date())
//        let validate: [MainList] = todo.filter { $0.isDone == true }
//        let grapeArray = Grape.Purple.allCases
//        var count = viewModel.currentPodoCount()
//        let today = count
//        var podo = count
//        
//        guard validate.isEmpty && todo.count == 0 else {
//            
//            // 오늘의 투두를 모두 완료했을 때
//            podo = count + 1
//            if podo >= 0 && podo <= 10 {
//                viewModel.updatePodo(isCurrent: true, fillCount: podo, completeDate: nil)
//            } else {    // 11 이상이 될 때
//                podo = 0
//                viewModel.updatePodo(isCurrent: false, fillCount: podo, completeDate: Date())
//                viewModel.createPodo()
//            }
//            grape.image = UIImage(named: grapeArray[podo].rawValue)!
//            return
//        }
//        //오늘의 투두를 모두 완성하지 못했을 때
//        podo = today
//        viewModel.updatePodo(isCurrent: true, fillCount: podo, completeDate: nil)
//        grape.image = UIImage(named: grapeArray[podo].rawValue)!
//    }
    
}

extension PodoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "podoCell", for: indexPath) as? PodoCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
    
}
