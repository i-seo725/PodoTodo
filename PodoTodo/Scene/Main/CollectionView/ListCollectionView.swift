////
////  ListCollectionViewController.swift
////  PodoTodo
////
////  Created by 이은서 on 2023/10/04.
////
//
//import UIKit
//import SnapKit
//import RealmSwift
//
//class ListCollectionView: UIView {
//    
//    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
//    var dataSource: UICollectionViewDiffableDataSource<Int, MainList>!
//    let viewModel = CollectionViewModel()
//    var tap: KindOfTab = .todo
//
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        addSubview(collectionView)
//        collectionView.snp.makeConstraints { make in
//            make.edges.equalTo(self.safeAreaLayoutGuide)
//        }
//        configureDataSource()
//        updateSnapshot()
//        collectionView.delegate = self
//        print(viewModel.todoList)
//    }
//
//    static func collectionViewLayout() -> UICollectionViewLayout {
//
//        var config = UICollectionLayoutListConfiguration(appearance: .plain)
//        config.headerMode = .firstItemInSection
//        config.backgroundColor = .clear
//
//        let layout = UICollectionViewCompositionalLayout.list(using: config)
//        return layout
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func configureDataSource() {
//        /*
//        let headerRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, MainList> { cell, indexPath, itemIdentifier in
//            var content = cell.defaultContentConfiguration()
//            content.text = itemIdentifier.temp
//            content.textProperties.font = UIFont(name: Font.jamsilRegular.rawValue, size: 16)!
//            content.textProperties.color = .black
//            cell.contentConfiguration = content
//            cell.accessories = [.outlineDisclosure()]
//            cell.tintColor = .firstGrape
//        }
//        */
//        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, MainList>(handler: { cell, indexPath, itemIdentifier in
//            var content = UIListContentConfiguration.cell()
//            content.text = itemIdentifier.contents
//            content.textProperties.color = .black
//            content.textProperties.font = UIFont(name: Font.jamsilLight.rawValue, size: 15)!
//
//            cell.contentConfiguration = content
//
//            //백그라운드 디자인, 전체
//            var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
//            backgroundConfig.backgroundColor = .clear
//
//            cell.backgroundConfiguration = backgroundConfig
//        })
//
//        //cellForItemAt
//        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
//            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
////            if indexPath.item == 0 {
////                return collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: itemIdentifier)
////            } else {
////                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
////            }
//        })
//
//    }
//
//
//    func updateSnapshot() {
//        print("?")
//        var snapshot = NSDiffableDataSourceSnapshot<Int, MainList>()
//        let sections = [11111]
//        snapshot.appendSections(sections)
//        snapshot.appendItems(viewModel.todoList, toSection: 11111)    //아이템은 list 기반으로 채울거임
//        dataSource.apply(snapshot)
//
////        for (index, item) in sections.enumerated() {
////            if index == 0 {
////                var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<MainList>()
////                sectionSnapshot.append([item])
////
////                switch tap {
////                case .todo:
////                    sectionSnapshot.ap
////                    sectionSnapshot.append(viewModel.listToArray(viewModel.todoList), to: item)
////                    sectionSnapshot.expand([item])
////                case .goal:
////                    sectionSnapshot.append(viewModel.listToArray(viewModel.goalList), to: item)
////                    sectionSnapshot.expand([item])
////                }
////                dataSource.apply(sectionSnapshot, to: item)
////
////            } else {
////                var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<MainList>()
////                sectionSnapshot.append([item])
////                sectionSnapshot.append(viewModel.listToArray(viewModel.todoList), to: item)
////                sectionSnapshot.expand([item])
////                dataSource.apply(sectionSnapshot, to: item)
////            }
////
////        }
//    }
//}
//
//extension ListCollectionView: UICollectionViewDelegate {
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let id = dataSource.itemIdentifier(for: indexPath) else {
//            print("id 가져오지 못함")
//            return
//        }
//       print(id)
//    }
//
//}
