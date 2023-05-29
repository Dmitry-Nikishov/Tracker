//
//  TrackerCategoryAddable.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 26.05.2023.
//

import Foundation

protocol TrackerCategoryAddable: AnyObject {
    func addNewTrackerCategory(_ category: TrackerCategory)
}

