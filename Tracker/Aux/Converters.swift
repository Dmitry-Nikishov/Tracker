//
//  Converters.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 09.06.2023.
//

import Foundation

final class Converters {
    static func daysToStringSuffix(days: Int) -> String {
        if days % 100 / 10 == 1 {
            return "дней"
        }
    
        switch days % 10 {
        case 1:
            return "день"
        case 2...4:
            return "дня"
        default:
            return "дней"
        }
    }
    
    private init() {}
}
