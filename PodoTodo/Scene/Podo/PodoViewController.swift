//
//  PodoViewController.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/09/30.
//

import UIKit
import Tabman
import Pageboy

class PodoViewController: BaseViewController {
    
    let grape = {
        let view = UIImageView()
        view.image = UIImage(named: Grape.Purple.complete.rawValue)!
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .black
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    
    override func configureView() {
        super.configureView()
        view.addSubview(grape)
    }
    
    override func setConstraints() {
        grape.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.6)
        }
    }
    
}
