//
//  UIViewController.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/18.
//

import UIKit

extension UIViewController {
    
    func presentSheetView(_ vc: UIViewController) {
        
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
