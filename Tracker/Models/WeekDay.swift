//
//  WeekDay.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 24.05.2023.
//

import Foundation

enum WeekDay: String, CaseIterable {
    case monday = "MONDAY"
    case tuesday = "TUESDAY"
    case wednesday = "WEDNESDAY"
    case thursday = "THURSDAY"
    case friday = "FRIDAY"
    case saturday = "SATURDAY"
    case sunday = "SUNDAY"
    
    private static let daysMapping = [
        "MONDAY".localized: "MONDAY_SHORT".localized,
        "TUESDAY".localized: "TUESDAY_SHORT".localized,
        "WEDNESDAY".localized: "WEDNESDAY_SHORT".localized,
        "THURSDAY".localized: "THURSDAY_SHORT".localized,
        "FRIDAY".localized: "FRIDAY_SHORT".localized,
        "SATURDAY".localized: "SATURDAY_SHORT".localized,
        "SUNDAY".localized: "SUNDAY_SHORT".localized
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
