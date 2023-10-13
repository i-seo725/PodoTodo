//
//  GroupTableView.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/14.
//

import UIKit
import SnapKit

class GroupTableViewCell: UITableViewCell {
    
    let colorPickerButton = {
        let view = UIColorWell()
        view.supportsAlpha = false
        view.selectedColor = .thirdGrape
        return view
    }()
    
    let groupNameTextField = {
        let view = UITextField()
        view.isUserInteractionEnabled = false
        view.borderStyle = .none
        view.placeholder = "그룹명을 입력해주세요"
        view.font = UIFont(name: Font.jamsilLight.rawValue, size: 15)
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
        contentView.addSubview(colorPickerButton)
        colorPickerButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(8)
        }
        
        contentView.addSubview(groupNameTextField)
        groupNameTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(colorPickerButton.snp.trailing).inset(-8)
            make.trailing.equalToSuperview().inset(8)
        }
    }
    
}
