//
//  UIViewController.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/18.
//

import UIKit

extension UIViewController {
    
    func presentSheetView(_ vc: UIViewController, height: CGFloat) {
        
        vc.modalPresentationStyle = .pageSheet
        guard let sheet = vc.sheetPresentationController else { return }
        if #available(iOS 16.0, *) {
            sheet.detents = [.custom(resolver: { context in
                return height
            })]
        } else {
            sheet.detents = [.medium()]
        }
        
        
        present(vc, animated: true)
    }
}
