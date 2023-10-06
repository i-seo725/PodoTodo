//
//  ListCollectionViewController.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/04.
//

import UIKit
import SnapKit

class ListCollectionView: UIView {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    var dataSource: UICollectionViewDiffableDataSource<Int, String>!
    let dummy = ["a@@@@@@@@@@@@@@", "b##########", "c$$$$$$$$$", "d%%%%%%%%%"]
    let dummy2 = ["aaaaaaaa", "bbbbbbbbb", "ccccccccc", "ddddddddddd"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        configureDataSource()
        updateSnapshot()
    }
    
    static func collectionViewLayout() -> UICollectionViewLayout {
        
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.headerMode = .firstItemInSection
        config.backgroundColor = .clear
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureDataSource() {
        
        let headerRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String> { cell, indexPath, itemIdentifier in
            var content = cell.defaultContentConfiguration()
            content.text = itemIdentifier
            content.textProperties.font = UIFont(name: Font.jamsilRegular.rawValue, size: 14)!
            cell.contentConfiguration = content
            cell.accessories = [.outlineDisclosure()]
            cell.tintColor = UIColor(rgb: Color.point.rawValue)
        }
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String>(handler: { cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.cell()
            content.text = itemIdentifier
            content.textProperties.color = UIColor(rgb: Color.text.rawValue)
            content.textProperties.font = UIFont(name: Font.jamsilLight.rawValue, size: 15)!
            content.secondaryText = "테스트 중"
            content.secondaryTextProperties.font = UIFont(name: Font.jamsilLight.rawValue, size: 12)!
            content.secondaryTextProperties.color = UIColor(rgb: Color.point.rawValue)
            
            cell.contentConfiguration = content
            
            //백그라운드 디자인, 전체
            var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
            backgroundConfig.backgroundColor = .clear
            
            cell.backgroundConfiguration = backgroundConfig
        })
        
        //cellForItemAt
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            if indexPath.item == 0 {
                return collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: itemIdentifier)
            } else {
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            }
        })
        
    }
    
    
    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        let sections = [0, 1]
        snapshot.appendSections(sections)
        dataSource.apply(snapshot)
        for (index, item) in sections.enumerated() {
            if index == 0 {
                var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<String>()
                let headerItem = "\(item) 섹션"
                sectionSnapshot.append([headerItem])
                let arrays = Array(0...9).map { "\($0)번째 셀"}
                sectionSnapshot.append(arrays, to: headerItem)
                sectionSnapshot.expand([headerItem])
                dataSource.apply(sectionSnapshot, to: item)
            } else {
                var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<String>()
                let headerItem = "\(item) 섹션"
                sectionSnapshot.append([headerItem])
                let arrays = Array(0...9).map { "이건 \($0)번째 셀"}
                sectionSnapshot.append(arrays, to: headerItem)
                sectionSnapshot.expand([headerItem])
                dataSource.apply(sectionSnapshot, to: item)
            }
          
        }
        
        //numberOfItemsInSection, 열거형도 고유한 값을 가지기 때문에 사용 가능, 겹치지 않으면 문자열도 가능
//        var snapshot2 = NSDiffableDataSourceSnapshot<Int, String>()    //스냅샷 찍을 수 있게 하는 구조체, diffableDataSource 제네릭과 같은 형태
//        snapshot.appendSections([0, 1])    //섹션 몇개 사용하겠다, 인덱스가 아니라 0부터 시작하지 않아도 됨, 리터럴한 값이라 열거형 활용
//        snapshot.appendItems(dummy, toSection: 0)    //아이템은 list 기반으로 채울거임
//        snapshot.appendItems(dummy2, toSection: 1)
//        dataSource.apply(snapshot)      //스냅샷 찍어서 뷰 갱신해라/반영해라
    }
}
