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
        view.font = UIFont(name: Font.jamsilLight.rawValue, size: 14)
        view.borderStyle = .roundedRect
        return view
    }()

    let datePicker = UIDatePicker()
    var selectedDate = Date()
    var table: UITableView!
    var listID: ObjectId!
    var groupID: ObjectId!
    var status = Present.add

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
        groupSelectButton.addTarget(self, action: #selector(groupSelectButtonTapped), for: .touchUpInside)
        updateViewByStatus()
    }
    
    @objc func receiveGroupID(notification: NSNotification) {
        guard let id = notification.userInfo?["groupID"] as? ObjectId else { return }
        groupID = id
    }
    
    func updateViewByStatus() {
        if status == .add {
            textField.placeholder = "할 일을 입력해주세요"
            dateTextField.text = selectedDate.dateToString()
        } else if status == .edit {
            guard let id = listID else {
                print("아이디 못받아옴")
                return
            }
            if let list = TodoRepository.shared.fetchFilterWithID(id: id).first {
                textField.text = list.contents
                dateTextField.text = list.date.dateToString()
            }
        }
    }
    
    @objc func enterButtonClicked(_ sender: UITextField) {

        guard let text = sender.text else { return }
        
        if status == .add {
            TodoRepository.shared.create(MainList(isTodo: true, contents: text, date: selectedDate, group: groupID))
        } else if status == .edit {
            TodoRepository.shared.update(id: listID, contents: text, date: selectedDate, group: groupID)
        }
        table.reloadData()
        dismiss(animated: true)
    }
    
    @objc func groupSelectButtonTapped() {
        let vc = GroupManagementViewController()
        vc.status = .select
        present(vc, animated: true)
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
        dateTextField.text = sender.date.dateToString()
        selectedDate = sender.date
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

        if text == "" {
            dateTextField.text = datePicker.date.dateToString()
            dateTextField.resignFirstResponder()
            selectedDate = datePicker.date
        } else {
            switch status {
            case .add:
                TodoRepository.shared.create(MainList(isTodo: true, contents: text, date: datePicker.date, group: groupID))
            case .edit:
                TodoRepository.shared.update(id: listID, contents: text, date: datePicker.date, group: groupID)
            case .select:
                break
            }

            table.reloadData()
            dismiss(animated: true)
        }
    }

}
