//
//  GoalAddViewController.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/07.
//

import UIKit
import RealmSwift

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
    
    let datePicker = UIDatePicker()
    var selectedDate: Date?
    var table: UITableView!
    var listID: ObjectId!
    var status = Present.add
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDatePicker()
        setupToolbar()
    }
 
    override func configureView() {
        super.configureView()
        view.addSubview(textField)
        view.addSubview(groupSelectButton)
        view.addSubview(dateTextField)
        textField.addTarget(self, action: #selector(enterButtonClicked), for: .editingDidEndOnExit)
    }
    
    @objc func enterButtonClicked(_ sender: UITextField) {
       
        guard let text = sender.text else { return }
        switch status {
        case .add:
            Repository.shared.create(MainList(isTodo: false, contents: text, date: selectedDate))
        case .edit:
            Repository.shared.update(id: listID, contents: text)
        }
        
        table.reloadData()
        dismiss(animated: true)
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
    
    func setDatePicker(){
        datePicker.datePickerMode = .date
        datePicker.minimumDate = .now
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        dateTextField.inputView = datePicker
    }
    
    @objc func dateChange(_ sender: UIDatePicker) {
        dateTextField.text = convertDateFormat(sender.date)
        selectedDate = sender.date
    }
    
    func convertDateFormat(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        let result = dateFormatter.string(from: date)
        return result
    }
    
    func setupToolbar() {
        let toolBar = UIToolbar()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolBar.items = [flexibleSpace, doneButton]
        toolBar.sizeToFit()
        dateTextField.inputAccessoryView = toolBar
    }
    
    @objc func doneButtonTapped() {
        guard let text = textField.text else {
            dateTextField.text = convertDateFormat(datePicker.date)
            dateTextField.resignFirstResponder()
            selectedDate = datePicker.date
            return
        }
        
        if text == "" {
            dateTextField.text = convertDateFormat(datePicker.date)
            dateTextField.resignFirstResponder()
            selectedDate = datePicker.date
        } else {
            switch status {
            case .add:
                Repository.shared.create(MainList(isTodo: false, contents: text, date: datePicker.date))
            case .edit:
                Repository.shared.update(id: listID, contents: text)
            }
            
            table.reloadData()
            dismiss(animated: true)
        }
    }
    
}