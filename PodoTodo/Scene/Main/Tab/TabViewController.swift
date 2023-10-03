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
    
    var vc = [TodoTab(), GoalTab()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        bar.layout.alignment = .centerDistributed
        bar.layout.contentMode = .intrinsic
        bar.backgroundView.style = .clear
        bar.layout.interButtonSpacing = 20
        
        
        bar.buttons.customize { (button) in
            button.tintColor = .orange
            button.selectedTintColor = .systemRed
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
            return TMBarItem(title: "Todo")
        } else {
            return TMBarItem(title: "Goal")
        }
    }
}
