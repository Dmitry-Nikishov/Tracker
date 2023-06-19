//
//  UIColor+Extension.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 23.05.2023.
//

import UIKit

extension UIColor {
    static var appBackground: UIColor { UIColor(named: "AppBackground") ?? .clear }
    static var appBlack: UIColor { UIColor(named: "AppBlack") ?? .clear }
    static var appBlue: UIColor { UIColor(named: "AppBlue") ?? .clear }
    static var appGray: UIColor { UIColor(named: "AppGray") ?? .clear }
    static var appLightGray: UIColor { UIColor(named: "AppLightGray") ?? .clear }
    static var appRed: UIColor { UIColor(named: "AppRed") ?? .clear }
    static var appWhite: UIColor { UIColor(named: "AppWhite") ?? .clear }
    static var appGreen: UIColor { UIColor(named: "5") ?? .clear }
    static var appRedLight: UIColor { UIColor(named: "AppRedLight") ?? .red }
    
    static var clr0: UIColor { UIColor(named: "1") ?? .clear}
    static var clr1: UIColor { UIColor(named: "2") ?? .clear}
    static var clr2: UIColor { UIColor(named: "3") ?? .clear}
    static var clr3: UIColor { UIColor(named: "4") ?? .clear}
    static var clr4: UIColor { UIColor(named: "5") ?? .clear}
    static var clr5: UIColor { UIColor(named: "6") ?? .clear}
    static var clr6: UIColor { UIColor(named: "7") ?? .clear}
    static var clr7: UIColor { UIColor(named: "8") ?? .clear}
    static var clr8: UIColor { UIColor(named: "9") ?? .clear}
    static var clr9: UIColor { UIColor(named: "10") ?? .clear}
    static var clr10: UIColor { UIColor(named: "11") ?? .clear}
    static var clr11: UIColor { UIColor(named: "12") ?? .clear}
    static var clr12: UIColor { UIColor(named: "13") ?? .clear}
    static var clr13: UIColor { UIColor(named: "14") ?? .clear}
    static var clr14: UIColor { UIColor(named: "15") ?? .clear}
    static var clr15: UIColor { UIColor(named: "16") ?? .clear}
    static var clr16: UIColor { UIColor(named: "17") ?? .clear}
    static var clr17: UIColor { UIColor(named: "18") ?? .clear}
    
    func getHex() -> String {
        let components = self.cgColor.components
        let red: CGFloat = components?[0] ?? 0.0
        let green: CGFloat = components?[1] ?? 0.0
        let blue: CGFloat = components?[2] ?? 0.0
        return String.init(
            format: "%02lX%02lX%02lX",
            lroundf(Float(red * 255)),
            lroundf(Float(green * 255)),
            lroundf(Float(blue * 255))
        )
    }
    
    func getColor(from hex: String) -> UIColor {
        var rgb: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgb)
        return UIColor(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}
