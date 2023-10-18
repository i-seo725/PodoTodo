//
//  PodoCollectionViewCell.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/18.
//

import UIKit
import SnapKit

class PodoCollectionViewCell: UICollectionViewCell {
    
    let podoImageView = {
        let view = UIImageView()
        view.image = UIImage(named: Grape.Purple.complete.rawValue)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(podoImageView)
        podoImageView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
