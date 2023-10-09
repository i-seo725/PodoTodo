//
//  TodoAddView.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/06.
//

import UIKit
import SnapKit

class TodoAddViewController: BaseViewController {
    
    let textField = {
        let view = UITextField()
        view.placeholder = "할 일을 입력해주세요"
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
    
    var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        view.addSubview(textField)
        view.addSubview(groupSelectButton)
        textField.addTarget(self, action: #selector(enterButtonTapped), for: .editingDidEndOnExit)
    }
    
    @objc func enterButtonTapped(_ sender: UITextField) {
        guard let text = sender.text else { return }
        Repository.shared.create(MainList(isTodo: true, contents: text))
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
    }
    
}
