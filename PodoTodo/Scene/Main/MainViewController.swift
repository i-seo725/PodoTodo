//
//  ViewController.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/09/25.
//

import UIKit
import FSCalendar
import SnapKit
import Firebase
import UserNotifications

final class MainViewController: BaseViewController {
    
    private let todoLabel = {
        let view = UILabel()
        view.text = "today_todo".localized
        view.font = UIFont.jamsilTitle
        return view
    }()
    private let todoUnderlineView = UIView()
    private var todoCalendar = {
        let view = FSCalendar()
        view.scope = .week
        view.locale = Locale(identifier: "us_US")
        
        //헤더 영역
        view.headerHeight = 0
        view.appearance.headerMinimumDissolvedAlpha = 0
        view.appearance.headerDateFormat = "main_date".localized
        view.appearance.headerTitleAlignment = .natural
        view.appearance.headerTitleColor = UIColor.black
        view.appearance.headerTitleFont = UIFont.jamsilTitle
        
        
        //날짜 영역
        view.appearance.weekdayTextColor = UIColor.black
        view.appearance.weekdayFont = UIFont.jamsilSubTitle
        view.appearance.titleWeekendColor = UIColor.gray
        view.appearance.selectionColor = UIColor.secondGrape
        
        //today
        view.appearance.todayColor = UIColor.thirdGrape
        view.appearance.todaySelectionColor = UIColor.thirdGrape
       
        return view
    }()
    private let todoTable = UITableView(frame: .zero, style: .grouped)
    var calendarDate = Date()
    
    
    private lazy var swipeUp = {
        let view = UISwipeGestureRecognizer(target: self, action: #selector(swipedUpAndDown))
        view.direction = .up
        todoCalendar.addGestureRecognizer(view)
        return view
    }()
    private lazy var swipeDown = {
        let view = UISwipeGestureRecognizer(target: self, action: #selector(swipedUpAndDown))
        view.direction = .down
        todoCalendar.addGestureRecognizer(view)
        return view
    }()
    
    let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @objc private func swipedUpAndDown(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .up {
            todoCalendar.setScope(.week, animated: true)
        } else if sender.direction == .down {
            todoCalendar.setScope(.month, animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        todoTable.reloadData()
    }
    
    @objc func updateToday() {
        DispatchQueue.main.async {
            self.todoCalendar.today = Date()
            self.todoCalendar.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func configureView() {
        super.configureView()
        configureCalendar()
        configureTableView()
        navigationItem.title = viewModel.configureNavigationTitle(Date())
        configureNavigationBar()
        todoUnderlineView.backgroundColor = .firstGrape
    }
    
    override func addSubViews() {
        view.addSubview(todoCalendar)
        view.addSubview(todoLabel)
        view.addSubview(todoUnderlineView)
        view.addSubview(todoTable)
    }
    func configureTableView() {
        todoTable.dataSource = self
        todoTable.delegate = self
        todoTable.rowHeight = UITableView.automaticDimension
        todoTable.backgroundColor = .white
        todoTable.layer.cornerRadius = 20
    }
    func configureCalendar() {
        todoCalendar.delegate = self
        todoCalendar.dataSource = self
        todoCalendar.addGestureRecognizer(swipeUp)
        todoCalendar.addGestureRecognizer(swipeDown)
        todoCalendar.allowsSelection = true
    }
    
    override func setConstraints() {
        todoCalendar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(330)
        }
        
        todoLabel.snp.makeConstraints { make in
            make.top.equalTo(todoCalendar.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        todoUnderlineView.snp.makeConstraints { make in
            make.top.equalTo(todoLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(todoLabel)
            make.height.equalTo(4)
        }
        
        todoTable.snp.makeConstraints { make in
            make.top.equalTo(todoUnderlineView.snp.bottom).offset(14)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureNavigationBar() {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(navigationBarTapped))
        if let navBar = navigationController?.navigationBar {
            navBar.addGestureRecognizer(recognizer)
            navBar.titleTextAttributes = [.font: UIFont.jamsilNav]
            navBar.backgroundColor = .clear
        }
        let listButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet")!, style: .plain, target: self, action: #selector(listButtonTapped))
        listButton.tintColor = .firstGrape
        navigationItem.leftBarButtonItem = listButton
        navigationItem.backButtonTitle = ""
    }
    
    @objc func navigationBarTapped() {
        todoCalendar.select(Date(), scrollToDate: true)
        navigationItem.title = viewModel.configureNavigationTitle(Date())
        calendarDate = Date()
        todoTable.reloadData()
    }
    
    @objc func listButtonTapped() {
        let vc = GroupManagementViewController()
        vc.status = .edit
        vc.handler? = {
            self.todoTable.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }


}

extension MainViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPage = todoCalendar.currentPage
        navigationItem.title = viewModel.configureNavigationTitle(currentPage)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        calendarDate = date
        viewModel.allTodoList(date: date)
        todoTable.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool){
        self.todoCalendar.snp.updateConstraints { (make) in
            make.height.equalTo(bounds.height)
        }
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        viewModel.countOfCalendarEvent(date: date)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return [UIColor.secondGrape]
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        return [UIColor.secondGrape]
    }
}


extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections(color: UIColor.thirdGrape.hexString)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = TableHeaderView()
        
        view.delegate = self
        view.sectionIndex = section
        
        if let group = viewModel.fetchGroup(), let color = group[section].color?.hexStringToUIColor() {
            view.underlineView.backgroundColor = color
            view.contentsLabel.text = group[section].groupName
        }
        
        return view
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let group = viewModel.fetchGroup()?[section] {
            guard let todoList = viewModel.todoList(date: calendarDate, groupID: group._id) else { return 0 }
            return todoList.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var contents = cell.defaultContentConfiguration()
        contents.textProperties.font = UIFont.jamsilContent
        
        guard let groupID = viewModel.fetchGroup()?[indexPath.section]._id, let todoList = viewModel.todoList(date: calendarDate, groupID: groupID)?[indexPath.row] else { return cell }
        
        if todoList.isDone == true {
            contents.attributedText = todoList.contents.strikeThrough()
        } else {
            contents.text = todoList.contents
        }
        
        cell.contentConfiguration = contents
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let groupID = viewModel.fetchGroup()?[indexPath.section]._id, let todoList = viewModel.todoList(date: calendarDate, groupID: groupID)?[indexPath.row] else { return }
        
        let vc = TodoAddViewController()
        vc.status = .edit
        vc.selectedDate = calendarDate
        vc.listID = todoList._id
        vc.groupID = todoList.group
        vc.handler = {
            tableView.reloadData()
            self.todoCalendar.reloadData()
        }
        presentSheetView(vc, height: 120)
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        guard let groupID = viewModel.fetchGroup()?[indexPath.section]._id, let todoList = viewModel.todoList(date: calendarDate, groupID: groupID)?[indexPath.row] else { return }
        
        if editingStyle == .delete {
            viewModel.deleteTodo(item: todoList)
            tableView.reloadSections(IndexSet(indexPath.section...indexPath.section), with: .automatic)
            todoCalendar.reloadData()
        }

    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard let groupID = viewModel.fetchGroup()?[indexPath.section]._id, let todoList = viewModel.todoList(date: calendarDate, groupID: groupID)?[indexPath.row] else { return nil }
        let doneButton = UIContextualAction(style: .normal, title: nil) { action, view, handler in
            
            self.viewModel.toggleTodo(date: self.calendarDate, indexPath: indexPath, groupID: groupID)
            self.todoTable.reloadSections(IndexSet(indexPath.section...indexPath.section), with: .automatic)
            
            handler(true)
        }
        doneButton.backgroundColor = .thirdGrape
        doneButton.image = todoList.isDone ? UIImage(systemName: "return")! : UIImage(systemName: "checkmark")!
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [doneButton])
        
        return swipeConfiguration
    }
    /*
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        guard let todo = TodoRepository.shared.fetchFilterOneDay(date: calendarDate)?[indexPath.row] else { return nil }

        guard let updateDate = todo.date.addingTimeInterval(86400).dateToString().stringToDate() else { return nil }
        let laterButton = UIContextualAction(style: .normal, title: "미루기") { action, view, handler in

            TodoRepository.shared.update(id: todo._id, contents: todo.contents, date: updateDate, group: todo.group)
            self.todoCalendar.reloadData()
            tableView.reloadSections(IndexSet(indexPath.section...indexPath.section), with: .automatic)
            handler(true)
        }

        laterButton.backgroundColor = .thirdGrape
        laterButton.image = UIImage(systemName: "arrowshape.right.fill")!

        let deleteButton = UIContextualAction(style: .destructive, title: nil) { action, view, handler in

            TodoRepository.shared.delete(todo)
            tableView.reloadSections(IndexSet(indexPath.section...indexPath.section), with: .automatic)
            self.todoCalendar.reloadData()
            handler(true)
        }

        deleteButton.image = UIImage(systemName: "trash.fill")!
        deleteButton.image?.withTintColor(.white)

        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteButton, laterButton])
        return swipeConfiguration

    }
    */
    
}

extension MainViewController: SectionViewDelegate {
    
    func sectionViewTapped(_ section: Int) {
        let vc = TodoAddViewController()
        vc.status = .add
        vc.selectedDate = calendarDate
        vc.groupID = viewModel.fetchGroup()?[section]._id
        vc.handler = {
            self.todoTable.reloadData()
            self.todoCalendar.reloadData()
        }
        presentSheetView(vc, height: 120)
    }
    
}
