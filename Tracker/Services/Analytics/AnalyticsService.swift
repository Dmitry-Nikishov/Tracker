//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 04.07.2023.
//

import Foundation
import YandexMobileMetrica

struct AnalyticsService {
    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(
            apiKey: AppConstants.YandexMobileMetrica.Keys.api
        ) else { return }
        YMMYandexMetrica.activate(with: configuration)
    }

    func sendReport(event: String, params: [AnyHashable: Any]) {
        YMMYandexMetrica.reportEvent(
            event,
            parameters: params,
            onFailure: { error in
                print("sendReport error: %@", error.localizedDescription)
            return
        })
    }
}
