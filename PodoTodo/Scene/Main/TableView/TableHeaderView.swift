//
//  TableViewCell.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/13.
//

import UIKit
import SnapKit

protocol SectionViewDelegate: AnyObject {
    func sectionViewTapped(_ section: Int)
}

class TableHeaderView: UITableViewHeaderFooterView {
    
    var sectionIndex = 0
    var contentsLabel = {
        let view = UILabel()
        view.text = "기본 그룹"
        view.numberOfLines = 1
        view.font = UIFont.jamsilSubTitle
        return view
    }()
    let underlineView = UIView()
    
    weak var delegate: SectionViewDelegate?
    var expandImage = {
        let view = UIImageView()
        view.image = UIImage(systemName: "plus")!
        view.tintColor = .firstGrape
        return view
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureView()
        setConstraints()
        makeTabGesture()
    }
    
    
    func makeTabGesture() {
        let recognizer = UITapGestureRecognizer()
        contentView.addGestureRecognizer(recognizer)
        recognizer.addTarget(self, action: #selector(sectionViewTapped))
    }
    
    @objc func sectionViewTapped() {
        delegate?.sectionViewTapped(sectionIndex)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        contentView.backgroundColor = .white
//        colorView.backgroundColor = .thirdGrape
        contentView.addSubview(contentsLabel)
        contentView.addSubview(expandImage)
        contentView.addSubview(underlineView)
        underlineView.backgroundColor = .lightGray
    }
    
    func setConstraints() {
        
        expandImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(expandImage.snp.height)
            make.centerY.equalToSuperview()
        }
        
        contentsLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(expandImage.snp.leading).inset(12)
            make.height.equalToSuperview()
        }
        
        underlineView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
}
