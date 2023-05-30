//
//  WeekDay.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 24.05.2023.
//

import Foundation

enum WeekDay: String, CaseIterable {
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятница"
    case saturday = "Суббота"
    case sunday = "Воскресенье"
    
    var dayNumberOfWeek: Int {
        switch self {
        case .monday:
            return 2
        case .tuesday:
            return 3
        case .wednesday:
            return 4
        case .thursday:
            return 5
        case .friday:
            return 6
        case .saturday:
            return 7
        case .sunday:
            return 1
        }
    }
}
