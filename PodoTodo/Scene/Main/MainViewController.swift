//
//  ViewController.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/09/25.
//

import UIKit
import FSCalendar
import Tabman
import Pageboy

class MainViewController: BaseViewController {
    
//    let weather = WeatherView()
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
    let tabView = UIView()
    var calendar = {
        let view = FSCalendar(frame: .zero)
        view.scope = FSCalendarScope.week
        view.locale = Locale(identifier: "us_US")
        
        //헤더 영역
        view.headerHeight = 70
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
       
        return view
    }()
    let groupButton = {
        let view = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: "list.bullet", withConfiguration: imageConfig)!
        view.setImage(image, for: .normal)
        view.tintColor = .firstGrape
//        view.backgroundColor = .blue
        return view
    }()
    
    let containedView = TabViewController()
    var todoTable: UITableView!
    var calendarDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setContainerView()
        todoTable = containedView.todoTable
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first)
    }
    
    func setContainerView() {
        containedView.view.frame = .zero
        self.addChild(containedView)
        tabView.addSubview(containedView.view)
        containedView.didMove(toParent: self)
    }
    override func configureView() {
        super.configureView()
        calendar.dataSource = self
        calendar.delegate = self
        view.addSubview(calendar)
        view.addSubview(tabView)
        view.addSubview(addButton)
        view.addSubview(groupButton)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    @objc func addButtonTapped() {
        
        let vc = TodoAddViewController()
        vc.modalPresentationStyle = .pageSheet
        guard let sheet = vc.sheetPresentationController else { return }
        if #available(iOS 16.0, *) {
            sheet.detents = [.custom(resolver: { context in
                return 60
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
        calendar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.4)
        }
        
        groupButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.leading.equalTo(calendar.snp.leading)
            make.size.equalTo(50)
        }
        
        tabView.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom).multipliedBy(0.62)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(calendar.snp.horizontalEdges)
        }
        
        addButton.snp.makeConstraints { make in
            make.size.equalTo(48)
            make.trailing.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.92)
            make.bottom.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.92)
        }
    }

}

extension MainViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        NotificationCenter.default.post(name: NSNotification.Name("selectedDate"), object: nil, userInfo: ["date": date])
        calendarDate = date
    }
}
