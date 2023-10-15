//
//  UIColor+Extension.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/09/29.
//

import UIKit

extension UIColor {
    
    class var firstGrape: UIColor { return UIColor(named: "firstGrape")! }
    class var secondGrape: UIColor { return UIColor(named: "secondGrape")! }
    class var thirdGrape: UIColor { return UIColor(named: "thirdGrape")! }
    class var fourthGrape: UIColor { return UIColor(named: "fourthGrape")! }
    
    var hexString: String? {
        guard let components = self.cgColor.components else { return nil }
        
        let red = Float(components[0])
        let green = Float(components[1])
        let blue = Float(components[2])
        return String(format: "#%02lX%02lX%02lX", lroundf(red * 255), lroundf(green * 255), lroundf(blue * 255))
    }
    
}
