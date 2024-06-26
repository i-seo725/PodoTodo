//
//  TodoAddView.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/06.
//

import UIKit
import SnapKit
import RealmSwift

protocol GroupAddProtocol: AnyObject {
    func groupTableReload()
}

class GroupAddViewController: BaseViewController {

    let textField = {
        let view = UITextField()
        view.borderStyle = .roundedRect
        view.clearButtonMode = .whileEditing
        view.font = UIFont.jamsilContent
        view.textColor = .black
        view.becomeFirstResponder()
        return view
    }()

    let colorSelectButton = UIColorWell()
    
    var status = Present.add
    var listID: ObjectId?
    var selectedColor = UIColor.thirdGrape.hexString
    
    let viewModel = GroupViewModel()
    weak var groupDelegate: GroupAddProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func configureView() {
        super.configureView()
        view.addSubview(textField)
        view.addSubview(colorSelectButton)
        textField.addTarget(self, action: #selector(enterButtonTapped), for: .editingDidEndOnExit)
        textField.delegate = self
        colorSelectButton.addTarget(self, action: #selector(colorSelected), for: .valueChanged)
        colorSelectButton.supportsAlpha = false
        updateViewByStatus()
    }
    
    func updateViewByStatus() {
        if status == .add {
            textField.placeholder = "add_group_placeholder".localized
            colorSelectButton.selectedColor = nil
        } else if status == .edit {
            guard let id = listID else {
                print("아이디 못받아옴")
                return
            }
            if let list = viewModel.filterGroup(id: id).first, let color = list.color {
                textField.text = list.groupName
                colorSelectButton.selectedColor = color.hexStringToUIColor()
            }
        }
    }

    @objc func enterButtonTapped(_ sender: UITextField) {
        switch status {
        case .add:
            guard let text = sender.text else { return }
            
            if text.isEmpty {
                let alert = UIAlertController(title: "empty_group_alert_title".localized, message: "empty_group_alert_message".localized, preferredStyle: .alert)
                let ok = UIAlertAction(title: "alert_ok".localized, style: .default)
                alert.addAction(ok)
                present(alert, animated: true)
            }

            else {
                viewModel.createGroup(item: GroupList(groupName: text, color: selectedColor))
                groupDelegate?.groupTableReload()
                dismiss(animated: true)
            }
 
            
        case .edit:
            guard let text = sender.text, let listID else { return }
            if text.isEmpty {
                let alert = UIAlertController(title: "change_group_alert_title".localized, message: "empty_group_alert_message".localized, preferredStyle: .alert)
                let ok = UIAlertAction(title: "alert_ok".localized, style: .default)
                alert.addAction(ok)
                present(alert, animated: true)
//                sender.text = "그룹명"
//                GroupRepository.shared.update(id: listID, groupName: "빈 그룹명", color: selectedColor)
            } else {
                viewModel.updateGroup(id: listID, name: text, color: selectedColor)
                groupDelegate?.groupTableReload()
                dismiss(animated: true)
            }
            
            
        case .select:
            return
        }
    }

    @objc func colorSelected(_ sender: UIColorWell) {
        selectedColor = sender.selectedColor?.hexString
    }


    override func setConstraints() {
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(70)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        colorSelectButton.snp.makeConstraints { make in
            make.trailing.equalTo(textField.snp.leading).offset(-8)
            make.size.equalTo(50)
            make.top.equalTo(textField.snp.top)
        }
    }

}

extension GroupAddViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        
        if text.count > 20 {
            return false
        } else {
            return true
        }
    }
    
}
