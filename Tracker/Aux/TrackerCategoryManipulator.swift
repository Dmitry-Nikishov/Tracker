//
//  TrackerCategoryManipulator.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 26.05.2023.
//

import Foundation

enum TrackerCategoryManipulator {
    static func appendSchedulePointIfNeeded(category: TrackerCategory, currentDate: Date) -> TrackerCategory {
        var trackerCategory = category
        if trackerCategory.trackers[0].schedule.isEmpty {
            if let schedulePoint = currentDate.getCurrentWeekDay() {
                trackerCategory.trackers[0].schedule.append(schedulePoint)
            }
        }
        return trackerCategory
    }
    
    static func getTrackersCategoryFilteredByDate(
        category: TrackerCategory,
        searchQuery: String,
        date: Date
    ) -> TrackerCategory {
        let trackers = category.trackers.filter(
            {
                ($0.text.contains(searchQuery) ||
                 searchQuery.isEmpty) &&
                ($0.schedule.contains(
                    where: {
                        $0.dayNumberOfWeek == date.getDayOfWeek()
                    }
                ))
            }
        )
        
        let resultCategory = TrackerCategory(
            title: category.title,
            trackers: trackers
        )
        return resultCategory
    }

}
