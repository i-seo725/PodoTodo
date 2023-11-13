//
//  GoalAddViewController.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/07.
//

import UIKit
import RealmSwift

class TodoAddViewController: BaseViewController {

    let textField = {
        let view = UITextField()
        view.borderStyle = .roundedRect
        view.clearButtonMode = .whileEditing
        view.font = UIFont.jamsilContent
        view.textColor = .black
        view.becomeFirstResponder()
        return view
    }()

    let groupSelectButton = {
        let view = UIButton()
        view.backgroundColor = .thirdGrape
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 0.5
        return view
    }()

    let dateTextField = {
        let view = UITextField()
        view.font = UIFont.jamsilContent
        view.borderStyle = .roundedRect
        return view
    }()

    let datePicker = UIDatePicker()
    var selectedDate = Date()
    var listID: ObjectId!
    var groupID: ObjectId?
    var status = Present.add
    var handler: (() -> Void)?
    
    let viewModel = TodoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDatePicker()
        setupToolbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveGroupID), name: NSNotification.Name("groupID"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    override func configureView() {
        super.configureView()
        view.addSubview(textField)
        view.addSubview(groupSelectButton)
        view.addSubview(dateTextField)
        textField.addTarget(self, action: #selector(enterButtonClicked), for: .editingDidEndOnExit)
        configureGroupButton()
        updateViewByStatus()
    }
    
    func configureGroupButton() {
        groupSelectButton.addTarget(self, action: #selector(groupSelectButtonTapped), for: .touchUpInside)
        groupSelectButton.layer.cornerRadius = 14
        
        guard let groupID else {
            if let id = viewModel.defaultGroup.first?._id, let color = viewModel.fetchGroup(id: id).first?.color?.hexStringToUIColor() {
                groupSelectButton.backgroundColor = color
            }
            return
        }
        if let color = viewModel.fetchGroup(id: groupID).first?.color?.hexStringToUIColor() {
                groupSelectButton.backgroundColor = color
            }
        
    }
    
    @objc func receiveGroupID(notification: NSNotification) {
        guard let id = notification.userInfo?["groupID"] as? ObjectId else { return }
        groupID = id
        
        guard let selected = viewModel.fetchGroup(id: id).first else { return }
        groupSelectButton.backgroundColor = selected.color?.hexStringToUIColor()
    }
    
    func updateViewByStatus() {
        if status == .add {
            textField.placeholder = "add_todo_placeholder".localized
            dateTextField.text = selectedDate.dateToString()
        } else if status == .edit {
            guard let id = listID else {
                print("아이디 못받아옴")
                return
            }
            if let list = viewModel.fetchSpecificTodo(id: id).first {
                textField.text = list.contents
                dateTextField.text = list.date.dateToString()
                datePicker.date = list.date
            }
        }
    }
    

    
    @objc func groupSelectButtonTapped() {
        let vc = GroupManagementViewController()
        vc.status = .select
//        let nav = UINavigationController(rootViewController: vc)
        present(vc, animated: true)
        
    }

    override func setConstraints() {
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(70)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        dateTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
            make.top.equalTo(textField.snp.bottom).offset(8)
        }
        groupSelectButton.snp.makeConstraints { make in
            make.leading.equalTo(dateTextField.snp.leading).inset(8)
            make.size.equalTo(28)
            make.centerY.equalTo(textField)
        }
    }

    func setDatePicker(){
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        dateTextField.inputView = datePicker
    }
    
    func emptyTodo() {
        let alert = UIAlertController(title: "empty_todo_alert_title".localized, message: "empty_todo_alert_message".localized, preferredStyle: .alert)
        let ok = UIAlertAction(title: "alert_ok".localized, style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }

    @objc func dateChange(_ sender: UIDatePicker) {
        dateTextField.text = sender.date.dateToString()
        guard let date = sender.date.dateToString().stringToDate() else { return }
        selectedDate = date
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
            dateTextField.text = datePicker.date.dateToString()
            dateTextField.resignFirstResponder()
            selectedDate = datePicker.date
            return
        }
        
        if text.isEmpty {
            dateTextField.text = datePicker.date.dateToString()
            dateTextField.resignFirstResponder()
            selectedDate = datePicker.date
        } else {
            guard let groupID else {
                if let id = viewModel.defaultGroup.first?._id {
                    switch status {
                    case .add:
                        viewModel.createTodo(MainList(isTodo: true, contents: text, date: datePicker.date, group: id))
                    case .edit:
                        viewModel.updateTodo(id: listID, contents: text, date: datePicker.date, group: id)
                    case .select:
                        return
                    }
                }
                handler?()
                dismiss(animated: true)
                return
            }
            guard let date = datePicker.date.dateToString().stringToDate() else { return }
            switch status {
            case .add:
                viewModel.createTodo(MainList(isTodo: true, contents: text, date: date, group: groupID))
            case .edit:
                viewModel.updateTodo(id: listID, contents: text, date: date, group: groupID)
            case .select:
                return
            }
            handler?()
            dismiss(animated: true)
        }
        

    }

    
    @objc func enterButtonClicked(_ sender: UITextField) {

        guard let text = sender.text else { return }
        if text.isEmpty {
            emptyTodo()
            return
        }
        guard let groupID else {
            if let id = viewModel.defaultGroup.first?._id {
                if status == .add {
                    viewModel.createTodo(MainList(isTodo: true, contents: text, date: selectedDate, group: id))
                } else if status == .edit {
                    viewModel.updateTodo(id: listID, contents: text, date: selectedDate, group: id)
                }
                handler?()
                dismiss(animated: true)
                return
            }
            return
        }
        
        if status == .add {
            viewModel.createTodo(MainList(isTodo: true, contents: text, date: selectedDate, group: groupID))
        } else if status == .edit {
            viewModel.updateTodo(id: listID, contents: text, date: selectedDate, group: groupID)
        }
        
        handler?()
        dismiss(animated: true)
    }

}
