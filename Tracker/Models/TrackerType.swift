//
//  TrackerType.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 24.05.2023.
//

import Foundation

enum TrackerType {
    case habit
    case event
    
    var labelText: String {
        switch self {
        case .habit:
            return "Новая привычка"
        case .event:
            return "Новое нерегулярное событие"
        }
    }
    
    var numberOfRowsForTableView: Int {
        switch self {
        case .habit:
            return 2
        case .event:
            return 1
        }
    }
    
    var heightForTableView: CGFloat {
        switch self {
        case .habit:
            return 149
        case .event:
            return 74
        }
    }
}

