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
        colorPickerButton.addTarget(self, action: #selector(colorPicked), for: .valueChanged)
        colorPickerButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(8)
        }
        
        contentView.addSubview(groupNameTextField)
        groupNameTextField.delegate = self
        groupNameTextField.addTarget(self, action: #selector(enterButtonTapped), for: .editingDidEndOnExit)
        groupNameTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(colorPickerButton.snp.trailing).inset(-8)
            make.trailing.equalToSuperview().inset(8)
        }
    }
    
    @objc func colorPicked(_ sender: UIColorWell) {
        print(sender.selectedColor) //rgb + alpha값
    }
    
    @objc func enterButtonTapped(_ sender: UITextField) {
        if let text = sender.text {
            if text.isEmpty {
                
            } else {
                sender.resignFirstResponder()
                sender.isUserInteractionEnabled = false
                sender.text = text
            }
        }
        
    }
    
}

extension GroupTableViewCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        if text.count > 20 || text.isEmpty {
            return false
        } else {
            return true
        }
    }
    
}

extension GroupTableViewCell: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        print(color)
    }
    
}
