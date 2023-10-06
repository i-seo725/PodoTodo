//
//  TabViewController.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/03.
//

import UIKit
import Tabman
import Pageboy

class TabViewController: TabmanViewController {
    
    private var vc: [UIViewController] = [TodoTab(), GoalTab()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        bar.layout.alignment = .centerDistributed
        bar.layout.contentMode = .intrinsic
        bar.backgroundView.style = .clear
        bar.layout.interButtonSpacing = 24
        bar.indicator.tintColor = UIColor(rgb: Color.today.rawValue)
        
        bar.buttons.customize { (button) in
            button.tintColor = UIColor(rgb: Color.point.rawValue)
            button.selectedTintColor = UIColor(rgb: Color.text.rawValue)
            button.font = UIFont(name: Font.jamsilRegular.rawValue, size: 20)!
        }
        addBar(bar, dataSource: self, at: .top)
    }
}

extension TabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        return vc.count
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        return vc[index]
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        return .at(index: 0)
    }
    
    
    func barItem(for bar: Tabman.TMBar, at index: Int) -> Tabman.TMBarItemable {
        
        if index == 0 {
            return TMBarItem(title: "할 일")
        } else {
            return TMBarItem(title: "목표")
        }
    }
}
