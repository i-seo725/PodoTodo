//
//  ViewController.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/09/25.
//

import UIKit
import FSCalendar

class MainViewController: BaseViewController {
    
    let todoLabel = {
        let view = UILabel()
        view.text = "오늘의 할 일"
        view.font = UIFont(name: Font.jamsilRegular.rawValue, size: 15)!
        return view
    }()
    
    let todoUnderlineView = UIView()
    let addButton = {
        let view = UIButton()
        view.layer.cornerRadius = 24
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        let image = UIImage(systemName: "plus", withConfiguration: imageConfig)
        view.setImage(image, for: .normal)
        view.tintColor = .white
        view.backgroundColor = .firstGrape
        
        view.layer.shadowOffset = .init(width: 5, height: 5)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 3
        return view
    }()
    var todoCalendar = {
        let view = FSCalendar()
        view.scope = .week
        view.locale = Locale(identifier: "us_US")
        
        //헤더 영역
        view.headerHeight = 0
        view.appearance.headerMinimumDissolvedAlpha = 0
        view.appearance.headerDateFormat = "YYYY년 MM월"
        view.appearance.headerTitleColor = UIColor.black
        view.appearance.headerTitleFont = UIFont(name: Font.jamsilRegular.rawValue, size: 18)
        
        //날짜 영역
        view.appearance.weekdayTextColor = UIColor.black
        view.appearance.weekdayFont = UIFont(name: Font.jamsilRegular.rawValue, size: 14)
        view.appearance.titleWeekendColor = UIColor.gray
        view.appearance.selectionColor = UIColor.secondGrape
        
        //today
        view.appearance.todayColor = UIColor.thirdGrape
        view.appearance.todaySelectionColor = UIColor.thirdGrape
       
        return view
    }()
    
    let todoTable = UITableView(frame: .zero, style: .grouped)
    var calendarDate = Date()
    var isOpen = [true]
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
        configureNavigationTitle()
        configureNavigationBar()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first)
    }
    
    override func configureView() {
        super.configureView()
        view.addSubview(todoCalendar)
        todoCalendar.delegate = self
        todoCalendar.dataSource = self
        view.addSubview(todoLabel)
        view.addSubview(todoUnderlineView)
        todoUnderlineView.backgroundColor = .firstGrape
        view.addSubview(todoTable)
        todoTable.dataSource = self
        todoTable.delegate = self
        todoTable.rowHeight = UITableView.automaticDimension
        view.addSubview(addButton)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    @objc func addButtonTapped() {
        
        let vc = TodoAddViewController()
        vc.modalPresentationStyle = .pageSheet
        guard let sheet = vc.sheetPresentationController else { return }
        if #available(iOS 16.0, *) {
            sheet.detents = [.custom(resolver: { context in
                return 120
            })]
        } else {
            sheet.detents = [.medium()]
        }
        vc.table = todoTable
        vc.status = .add
        vc.calendarDate = calendarDate
        present(vc, animated: true)
    }
    
    override func setConstraints() {
        todoCalendar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.4)
        }
        
        todoLabel.snp.makeConstraints { make in
            make.top.equalTo(todoCalendar.snp.bottom).multipliedBy(0.5)
            make.centerX.equalToSuperview()
        }
        
        todoUnderlineView.snp.makeConstraints { make in
            make.top.equalTo(todoLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(todoLabel)
            make.height.equalTo(4)
        }
        
        addButton.snp.makeConstraints { make in
            make.size.equalTo(48)
            make.trailing.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.92)
            make.bottom.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.92)
        }
        
        todoTable.snp.makeConstraints { make in
            make.top.equalTo(todoUnderlineView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func configureNavigationTitle() {
        
        let formatter = DateFormatter()
        formatter.locale = .autoupdatingCurrent
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateFormat = "yyyy년 MM월"
        var result = ""
        if let date = todoCalendar.selectedDate {
            result = formatter.string(from: date)
        } else {
            result = formatter.string(from: Date())
        }
        
        navigationItem.title = result
    }
    
    func configureNavigationBar() {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(navigationBarTapped))
        if let navBar = navigationController?.navigationBar {
            navBar.addGestureRecognizer(recognizer)
            navBar.titleTextAttributes = [.font: UIFont(name: Font.jamsilRegular.rawValue, size: 18)]
            navBar.backgroundColor = .white
        }
        let listButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet")!, style: .plain, target: self, action: #selector(listButtonTapped))
        listButton.tintColor = .firstGrape
        navigationItem.leftBarButtonItem = listButton
        navigationItem.backButtonTitle = ""
    }
    
    @objc func navigationBarTapped() {
        todoCalendar.select(Date(), scrollToDate: true)
        configureNavigationTitle()
        calendarDate = Date()
        todoTable.reloadData()
    }
    
    @objc func listButtonTapped() {
        self.navigationController?.pushViewController(GroupManagementViewController(), animated: true)
    }
}

extension MainViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        configureNavigationTitle()
        calendarDate = date
        viewModel.todoList(date: date)
        todoTable.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool){
//        self.todoCalendar.snp.updateConstraints { (make) in
//            make.height.equalTo(bounds.height)
//        }
//        self.view.layoutIfNeeded()
    }
}


extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = TableHeaderView()
        view.delegate = self
        view.expandImage.image = isOpen[section] ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down")
        view.sectionIndex = section
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isOpen[section] {
            return viewModel.todoList(date: calendarDate).count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        var contents = cell.defaultContentConfiguration()
        contents.textProperties.font = UIFont(name: Font.jamsilLight.rawValue, size: 15)!
        
        let todoList = viewModel.todoList(date: calendarDate)[indexPath.row]
        
        if todoList.isDone == true {
            contents.attributedText = todoList.contents.strikeThrough()
        } else {
            contents.text = todoList.contents
        }
        
        cell.contentConfiguration = contents
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let todoList = viewModel.todoList(date: calendarDate)[indexPath.row]
        
        let text = todoList.contents
        let id = todoList._id
       
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            TodoRepository.shared.delete(viewModel.todoList(date: calendarDate)[indexPath.row])
            tableView.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let doneButton = UIContextualAction(style: .normal, title: nil) { action, view, handler in
            
            self.viewModel.toggleTodo(date: self.calendarDate, indexPath: indexPath)
            self.todoTable.reloadData()
            
            handler(true)
        }
        doneButton.backgroundColor = .thirdGrape
        doneButton.image = viewModel.todoList(date: calendarDate)[indexPath.row].isDone ? UIImage(systemName: "return")! : UIImage(systemName: "checkmark")!
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [doneButton])
        
        return swipeConfiguration
    }
    
    
}

extension MainViewController: SectionViewDelegate {
    
    func sectionViewTapped(_ section: Int) {
        isOpen[section].toggle()
        todoTable.reloadSections(IndexSet(section...section), with: .fade)
    }
    
}
