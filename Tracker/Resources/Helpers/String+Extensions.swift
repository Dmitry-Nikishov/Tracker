//
//  String+Extensions.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 05.07.2023.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
