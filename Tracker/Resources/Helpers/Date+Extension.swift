//
//  Date+Extension.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 24.05.2023.
//

import Foundation

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
}
