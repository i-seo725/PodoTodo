//
//  GoalAddViewController.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/07.
//

import UIKit

class GoalAddViewController: BaseViewController {
    
    let textField = {
        let view = UITextField()
        view.placeholder = "목표를 입력해주세요"
        view.borderStyle = .roundedRect
        view.font = UIFont(name: Font.jamsilLight.rawValue, size: 14)
        view.textColor = .black
        view.becomeFirstResponder()
        return view
    }()
    
    let groupSelectButton = {
        let view = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .light)
        let image = UIImage(systemName: "list.bullet", withConfiguration: imageConfig)
        view.setImage(image, for: .normal)
        view.tintColor = .firstGrape
        return view
    }()
    
    let dateTextField = {
        let view = UITextField()
        view.placeholder = "마감일자를 선택해주세요"
        view.font = UIFont(name: Font.jamsilLight.rawValue, size: 14)
        view.borderStyle = .roundedRect
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDatePicker()
    }
 
    override func configureView() {
        super.configureView()
        view.addSubview(textField)
        view.addSubview(groupSelectButton)
        view.addSubview(dateTextField)
    }
    
    override func setConstraints() {
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(70)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        groupSelectButton.snp.makeConstraints { make in
            make.trailing.equalTo(textField.snp.leading).offset(-8)
            make.size.equalTo(50)
            make.top.equalTo(textField.snp.top)
        }
        dateTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
            make.top.equalTo(textField.snp.bottom).offset(8)
        }
        
    }
    
    func setDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.minimumDate = .now
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        dateTextField.inputView = datePicker
    }
    
    @objc func dateChange(_ sender: UIDatePicker) {
        print(sender.date)
    }
    
}
