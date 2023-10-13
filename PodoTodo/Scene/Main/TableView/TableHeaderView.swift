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
        view.font = UIFont(name: Font.jamsilLight.rawValue, size: 13)
        return view
    }()
    
    weak var delegate: SectionViewDelegate?
    var colorView = UIView()
    var expandImage = {
        let view = UIImageView()
        view.image = UIImage(systemName: "chevron.up")!
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
        print(sectionIndex)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        contentView.addSubview(colorView)
        colorView.backgroundColor = .thirdGrape
        contentView.addSubview(contentsLabel)
        contentView.addSubview(expandImage)
    }
    
    func setConstraints() {
        colorView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(12)
            make.leading.equalToSuperview().inset(8)
        }
        
        expandImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.width.equalTo(expandImage.snp.height)
        }
        
        contentsLabel.snp.makeConstraints { make in
            make.leading.equalTo(colorView.snp.trailing).inset(-8)
            make.trailing.equalTo(expandImage.snp.leading).inset(12)
            make.height.equalToSuperview()
        }
    }
    
}
