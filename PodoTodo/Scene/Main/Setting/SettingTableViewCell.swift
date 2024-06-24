//
//  SettingTableViewCell.swift
//  PodoTodo
//
//  Created by 이은서 on 6/20/24.
//

import UIKit
import SnapKit

class SettingTableViewCell: UITableViewCell {
    
    var title = {
        let view = UILabel()
        view.text = "알림 설정"
//        view.font = UIFont.jamsilSubTitle
        return view
    }()
    
    let alertSwitch = UISwitch()
    let timePicker = UIDatePicker()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        contentView.addSubview(title)
        contentView.addSubview(alertSwitch)
        contentView.addSubview(timePicker)
        timePicker.datePickerMode = .time
        timePicker.isHidden = true
    }
    
    func setConstraints() {
        title.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        
        alertSwitch.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
        }
        
        timePicker.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
        }
    }
}
