//
//  UIColor+Extensions.swift
//  MyToList
//
//  Created by Vladimir Eryshev on 28.07.2025.
//

import UIKit
import Foundation

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3:
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: 
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: CGFloat(alpha) / 255
        )
    }
    
    static let customGray = UIColor(hexString: "#272729")
    
    static let changeableGray = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ? UIColor.lightText: UIColor.darkText
    }
    
    static let changeableBlack = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ? UIColor.white: UIColor.black
    }
    
    static let changeableYellow = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ? UIColor.systemYellow: UIColor.systemOrange
    }
    
    static let changeableLightGray = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ? UIColor.customGray : UIColor.systemGray5
    }
}
