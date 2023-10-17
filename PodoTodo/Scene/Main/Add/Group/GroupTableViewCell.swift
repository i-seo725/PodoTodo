//
//  GroupTableView.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/14.
//

import UIKit
import SnapKit

class GroupTableViewCell: UITableViewCell {
    
    let colorView = UIView()
    let groupNameLabel = {
        let view = UILabel()
        view.font = UIFont(name: Font.jamsilLight.rawValue, size: 13)
        view.text = "20자 제한 주기"
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        contentView.addSubview(colorView)
        colorView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
            make.leading.equalToSuperview().inset(8)
        }
        colorView.layer.cornerRadius = 10
        
        contentView.addSubview(groupNameLabel)
        groupNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(colorView.snp.trailing).inset(-8)
            make.trailing.equalToSuperview().inset(8)
        }
    }
    
    @objc func colorPicked(_ sender: UIColorWell) {
        //        print(sender.selectedColor?.cgColor.components)
        let a = sender.selectedColor?.hexString
        print(a)
    }

    
    
    
}
