//
//  AppConstants.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 04.07.2023.
//

import Foundation

struct AppConstants {
    struct YandexMobileMetrica {
        struct Keys {
            static let api = "9b075269-9952-4ad9-9774-dcaef2ecddc7"
        }

        struct Events {
            static let open = "open"
            static let close = "close"
            static let click = "click"
        }

        struct Screens {
            static let trackers = "Main"
            static let trackerSelection = "TrackerSelection"
            static let trackerCreation = "TrackerCreation"
            static let trackerCategorySelection = "TrackerCategorySelection"
            static let categoryCreation = "CategoryCreation"
            static let scheduleConfiguration = "ScheduleConfiguration"
            static let statistics = "Statistics"
        }
        
        struct Items {
            static let addTrack = "add_track"
            static let completeTrack = "track"
            static let filter = "filter"
            static let pin = "pin"
            static let unpin = "unpin"
            static let edit = "edit"
            static let delete = "delete"
            static let habit = "habit_creation"
            static let event = "non_regular_event_creation"
            static let cancelTrackerCreation = "cancel_tracker_creation"
            static let confirmTrackerCreation = "confirm_tracker_creation"
            static let color = "color_choosen_"
            static let emoji = "emoji_choosen_"
            static let addCategory = "add_category"
            static let confirmCategoryCreation = "confirm_category_creation"
            static let confirmSchedule = "confirm_schedule"
        }
    }
}
