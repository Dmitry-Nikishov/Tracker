//
//  Date+Extension.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 24.05.2023.
//

import Foundation

private let dateDefaultFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .none
    dateFormatter.timeZone = TimeZone(identifier: "GMT")
    return dateFormatter
}()

private let defaultFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ru_RU")
    formatter.dateFormat = "dd.MM.YY"
    return formatter
}()

extension Date {
    func isEqualByDayGranularity(other: Date) -> Bool {
        Calendar.current.isDate(
            self,
            equalTo: other,
            toGranularity: .day
        )
    }
    
    func getDayOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    
    func getCurrentWeekDay() -> WeekDay? {
        guard let dayId = Calendar.current.dateComponents([.weekday], from: self).weekday else {
            return nil
        }
        
        var currentDay = dayId
        if dayId == 1 {
            currentDay = 8
        }
        
        return WeekDay.allCases[currentDay - 2]
    }
    
    var dateString: String { defaultFormatter.string(from: self) }
    var weekDayIndex: Int { Calendar.current.component(.weekday, from: self) }
    
    static func convertFromString(_ string: String) -> Date {
        dateDefaultFormatter.date(from: string) ?? Date()
    }

    static func randomFromRange(start: Date, end: Date) -> Date {
        var date1 = start
        var date2 = end
        if date2 < date1 {
            let temp = date1
            date1 = date2
            date2 = temp
        }
        let span = TimeInterval.random(in: date1.timeIntervalSinceNow...date2.timeIntervalSinceNow)
        return Date(timeIntervalSinceNow: span)
    }

    static var randomDate: String {
        let date1 = Date.convertFromString("01.01.1980")
        let date2 = Date.convertFromString("01.01.2007")
        return Date.randomFromRange(start: date1, end: date2).dateString
    }
}

