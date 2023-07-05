//
//  StatisticsScreenViewModel.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 04.07.2023.
//

import UIKit

final class StatisticsScreenViewModel {
    @Observable
    private(set) var shouldStatisticsBeShown: Bool = false

    private let recordStore = TrackerRecordStore()
    
    func checkStoreForData() {
        shouldStatisticsBeShown = !recordStore.trackers.isEmpty
    }

    func getNumberOfCompletedTrackers() -> String {
        return "\(recordStore.trackers.count)"
    }

    func getNumberOfIdealDays() -> String {
        return "-"
    }

    func getAverage() -> String {
        return "-"
    }

    func getBestPeriod() -> String {
        return "-"
    }
}


