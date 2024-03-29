//
//  Tracker.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 24.05.2023.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let emoji: String
    let color: UIColor
    var schedule: [WeekDay]
    var isPinned: Bool
    let categoryName: String
}
