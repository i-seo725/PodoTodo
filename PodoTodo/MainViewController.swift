//
//  ViewController.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/09/25.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        for item in UIFont.familyNames {
            print(item)
            for name in UIFont.fontNames(forFamilyName: item) {
                print("====\(name)")
            }
        }
    }


}

