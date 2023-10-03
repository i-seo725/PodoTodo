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
        view.setImage(UIImage(systemName: "plus"), for: .normal)
        view.tintColor = UIColor(rgb: Color.background.rawValue)
        view.backgroundColor = UIColor(rgb: Color.point.rawValue)
        
        view.imageEdgeInsets = .init(top: 7, left: 3, bottom: 7, right: 7)
        view.contentVerticalAlignment = .fill
        view.contentHorizontalAlignment = .fill
        
        view.layer.shadowOffset = .init(width: 5, height: 5)
        view.layer.shadowOpacity = 0.4
        view.layer.shadowRadius = 5
        return view
    }()
    let tabView = {
        let view = UIView()
        view.backgroundColor = .brown
        view.addSubview(TabViewController().view)

        return view
    }()
    var calendar = {
        let view = FSCalendar(frame: .zero)
        view.scope = FSCalendarScope.week
        view.locale = Locale(identifier: "us_US")
        
        //헤더 영역
        view.headerHeight = 70
        view.appearance.headerMinimumDissolvedAlpha = 0
        view.appearance.headerDateFormat = "YYYY년 MM월"
        view.appearance.headerTitleColor = UIColor(rgb: Color.text.rawValue)
        view.appearance.headerTitleFont = UIFont(name: Font.jamsilRegular.rawValue, size: 18)
        
        //날짜 영역
        view.appearance.weekdayTextColor = UIColor(rgb: Color.point.rawValue)
        view.appearance.weekdayFont = UIFont(name: Font.jamsilRegular.rawValue, size: 14)
        view.appearance.titleWeekendColor = UIColor.gray
        view.appearance.selectionColor = UIColor(rgb: Color.selected.rawValue)
        view.backgroundColor = UIColor.systemYellow
        
        //today
        view.appearance.todayColor = UIColor(rgb: Color.today.rawValue)
       
        return view
    }()
    private var viewControllers: [UIViewController] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setConstraints()
        configureTabbar()
        calendar.dataSource = self
        calendar.delegate = self
        addChild(TabViewController())
    }
    
    func configureView() {
        view.backgroundColor = UIColor(rgb: Color.background.rawValue)
        view.addSubview(calendar)
        view.addSubview(weather)
        view.addSubview(tabView)
        view.addSubview(addButton)
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
            make.height.equalTo(80)
        }
        
        tabView.snp.makeConstraints { make in
            make.top.equalTo(weather.snp.bottom).multipliedBy(1.05)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(weather.snp.horizontalEdges)
        }
        
        addButton.snp.makeConstraints { make in
            make.size.equalTo(48)
            make.trailing.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.88)
            make.bottom.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.92)
        }
    }
    func configureTabbar() {
//        self.dataSource = self
        viewControllers.append(TodoTab())
        viewControllers.append(GoalTab())
    }

}

extension MainViewController: FSCalendarDelegate, FSCalendarDataSource {
   
}

//extension MainViewController: PageboyViewControllerDataSource {
//    
//    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
//        <#code#>
//    }
//    
//    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
//        <#code#>
//    }
//    
//    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
//        <#code#>
//    }
//    
//    
//}
