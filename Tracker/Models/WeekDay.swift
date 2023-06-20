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
    
    private static let daysMapping = [
        "Понедельник": "Пн",
        "Вторник": "Вт",
        "Среда": "Ср",
        "Четверг": "Чт",
        "Пятница": "Пт",
        "Суббота": "Сб",
        "Воскресенье": "Вс"
    ]

    static func getShortWeekDay(for day: String) -> String? {        
        return daysMapping[day]
    }

    static func getWeekDay(for date: Date) -> WeekDay {
        var currentWeekDay: WeekDay {
            switch date.weekDayIndex {
            case 1:
                return .sunday
            case 2:
                return .monday
            case 3:
                return .tuesday
            case 4:
                return .wednesday
            case 5:
                return .thursday
            case 6:
                return .friday
            case 7:
                return .saturday
            default:
                return .monday
            }
        }
        return currentWeekDay
    }

}
