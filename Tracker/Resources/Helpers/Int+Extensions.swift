//
//  Int+Extensions.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 05.07.2023.
//

import Foundation

extension Int {
    var localized: String {
        return String.localizedStringWithFormat(
            NSLocalizedString(
                "daysStreak",
                comment: ""
            ),
            self
        )
    }
}
