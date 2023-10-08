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

class MainViewController: UIViewController {
    
    let weather = WeatherView()
    let addButton = {
        let view = UIButton()
        view.layer.cornerRadius = 24
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        let image = UIImage(systemName: "plus", withConfiguration: imageConfig)
        view.setImage(image, for: .normal)
        view.tintColor = .fourthGrape
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
//        view.backgroundColor = UIColor.fourthGrape
        
        //today
        view.appearance.todayColor = UIColor.thirdGrape
       
        return view
    }()
    
    var tab: KindOfTab = .todo
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setConstraints()
        calendar.dataSource = self
        calendar.delegate = self
        setContainerView()
        receiveNotification()
        
    }
    
    func setContainerView() {
        let containedView = TabViewController()
        
        containedView.view.frame = .zero
        self.addChild(containedView)
        tabView.addSubview(containedView.view)
        containedView.didMove(toParent: self)
    }
    
    func configureView() {
        view.backgroundColor = .white
        view.addSubview(calendar)
        view.addSubview(weather)
        view.addSubview(tabView)
        view.addSubview(addButton)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    @objc func addButtonTapped() {
        switch tab {
        case .todo:
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
            present(vc, animated: true)
        case .goal:
            let vc = GoalAddViewController()
            vc.modalPresentationStyle = .pageSheet
            guard let sheet = vc.sheetPresentationController else { return }
            if #available(iOS 16.0, *) {
                sheet.detents = [.custom(resolver: { context in
                    return 120
                })]
            } else {
                sheet.detents = [.medium()]
            }
            present(vc, animated: true)
        }
        
        
    }

    func receiveNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(receiveTodoValue), name: NSNotification.Name("todo"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveGoalValue), name: NSNotification.Name("goal"), object: nil)
    }
    
    @objc func receiveTodoValue(notification: NSNotification) {
        guard let value = notification.userInfo?["tab"] as? KindOfTab else { return }
        tab = value
        
    }
    
    @objc func receiveGoalValue(notification: NSNotification) {
        guard let value = notification.userInfo?["tab"] as? KindOfTab else { return }
        tab = value
    }
    
    func setConstraints() {
        calendar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.4)
        }
        
        weather.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom).multipliedBy(0.6)
            make.horizontalEdges.equalTo(calendar.snp.horizontalEdges)
            make.height.equalTo(calendar.snp.height).multipliedBy(0.2)
        }
        
        tabView.snp.makeConstraints { make in
            make.top.equalTo(weather.snp.bottom).multipliedBy(1.05)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(weather.snp.horizontalEdges)
        }
        
        addButton.snp.makeConstraints { make in
            make.size.equalTo(48)
            make.trailing.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.92)
            make.bottom.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.92)
        }
    }

}

extension MainViewController: FSCalendarDelegate, FSCalendarDataSource {
   
}
