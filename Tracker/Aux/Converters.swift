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
            return "DAYS".localized
        }
    
        switch days % 10 {
        case 1:
            return "DAY".localized
        case 2...4:
            return "DAYS_LANGUAGE_SENSITIVE".localized
        default:
            return "DAYS".localized
        }
    }
    
    private init() {}
}
