//
//  ViewController.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/09/25.
//

import UIKit
import FSCalendar
import SnapKit

class MainViewController: BaseViewController {
    
    let todoLabel = {
        let view = UILabel()
        view.text = "오늘의 할 일"
        view.font = UIFont.jamsilTitle
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
    let todoTable = UITableView(frame: .zero, style: .grouped)
    var calendarDate = Date()
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        todoTable.reloadData()
    }
    
    override func configureView() {
        super.configureView()
        addSubViews()
        configureCalendar()
        configureTableView()
        navigationItem.title = viewModel.configureNavigationTitle(Date())
        configureNavigationBar()
        todoUnderlineView.backgroundColor = .firstGrape
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    func addSubViews() {
        view.addSubview(todoCalendar)
        view.addSubview(todoLabel)
        view.addSubview(todoUnderlineView)
        view.addSubview(todoTable)
        view.addSubview(addButton)
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
    @objc func addButtonTapped() {
        let vc = TodoAddViewController()
        vc.status = .add
        vc.selectedDate = calendarDate
      
        vc.handler = {
            self.todoTable.reloadData()
            self.todoCalendar.reloadData()
        }
        presentSheetView(vc, height: 120)
    }
    
    override func setConstraints() {
        todoCalendar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)//.offset(-30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(330)//.multipliedBy(0.4)
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
        
        addButton.snp.makeConstraints { make in
            make.size.equalTo(48)
            make.trailing.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.92)
            make.bottom.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.92)
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
    
    private lazy var swipeUp = {
        let view = UISwipeGestureRecognizer(target: self, action: #selector(swipedUpAndDown))
        view.direction = .up
        return view
    }()
    private lazy var swipeDown = {
        let view = UISwipeGestureRecognizer(target: self, action: #selector(swipedUpAndDown))
        view.direction = .down
        return view
    }()
    
    @objc private func swipedUpAndDown(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .up {
            todoCalendar.setScope(.week, animated: true)
        } else if sender.direction == .down {
            todoCalendar.setScope(.month, animated: true)
        }
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
        let dateArray: [Date] = TodoRepository.shared.fetch().map { $0.date }
        print(dateArray, "저장된 날짜")
        
        guard let calendarDate = date.dateToString().stringToDate() else { return 0 }
        
        if dateArray.contains(calendarDate){
            return 1
        } else {
            return 0
        }
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
        if GroupRepository.shared.fetch().count == 0 {
            GroupRepository.shared.create(GroupList(groupName: "기본 그룹", color: UIColor.thirdGrape.hexString, isDefault: true))
        }
        return GroupRepository.shared.fetch().count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = TableHeaderView()
        let isOpen = GroupRepository.shared.fetch()[section].isOpen
        view.delegate = self
        view.expandImage.image = isOpen ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down")
        view.contentsLabel.text = GroupRepository.shared.fetch()[section].groupName
         
        view.sectionIndex = section
        
        if let color = GroupRepository.shared.fetch()[section].color?.hexStringToUIColor() {
            view.underlineView.backgroundColor = color
        }
        return view
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let group = GroupRepository.shared.fetch()[section]
        if group.isOpen {
            return TodoRepository.shared.fetchFilter(isTodo: true, date: calendarDate, group: group._id).count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var contents = cell.defaultContentConfiguration()
        contents.textProperties.font = UIFont.jamsilContent
        
        let groupID = GroupRepository.shared.fetch()[indexPath.section]._id
        
        let todoList = TodoRepository.shared.fetchFilter(isTodo: true, date: calendarDate, group: groupID)[indexPath.row]
        
        if todoList.isDone == true {
            contents.attributedText = todoList.contents.strikeThrough()
        } else {
            contents.text = todoList.contents
        }
        
        cell.contentConfiguration = contents
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todoList = viewModel.todoList(date: calendarDate, groupID: GroupRepository.shared.fetch()[indexPath.section]._id)[indexPath.row]
        
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
        if editingStyle == .delete {
            
            TodoRepository.shared.delete(viewModel.todoList(date: calendarDate, groupID: GroupRepository.shared.fetch()[indexPath.section]._id)[indexPath.row])
            tableView.reloadSections(IndexSet(indexPath.section...indexPath.section), with: .automatic)
            todoCalendar.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let groupID = GroupRepository.shared.fetch()[indexPath.section]._id
        let doneButton = UIContextualAction(style: .normal, title: nil) { action, view, handler in
            
            self.viewModel.toggleTodo(date: self.calendarDate, indexPath: indexPath, groupID: groupID)
            self.todoTable.reloadSections(IndexSet(indexPath.section...indexPath.section), with: .automatic)
            
            handler(true)
        }
        doneButton.backgroundColor = .thirdGrape
        doneButton.image = viewModel.todoList(date: calendarDate, groupID: groupID)[indexPath.row].isDone ? UIImage(systemName: "return")! : UIImage(systemName: "checkmark")!
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [doneButton])
        
        return swipeConfiguration
    }
    
    
}

extension MainViewController: SectionViewDelegate {
    
    func sectionViewTapped(_ section: Int) {
        let group = GroupRepository.shared.fetch()[section]
        GroupRepository.shared.isOpenUpdate(id: group._id, isOpen: !group.isOpen)
        todoTable.reloadSections(IndexSet(section...section), with: .fade)
    }
    
}
