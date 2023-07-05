//
//  OnboardingScreenViewModel.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 26.06.2023.
//

import UIKit

final class OnboardingScreenViewModel {
    private let pages: [UIViewController] = [
        OnboardingPageController(
            text: "MONITOR_WHAT_YOU_NEED".localized,
            backgroundImage: UIImage(
                named: "OnboardingFirstPage"
            ) ?? UIImage()),
        OnboardingPageController(
            text: "EVEN_IF_IT_IS_NOT_LITERS_OF_WATER_OR_YOGA".localized,
            backgroundImage: UIImage(
                named: "OnboardingSecondPage"
            ) ?? UIImage())
    ]
    
    func getFirstPage() -> UIViewController? {
        pages.first
    }

    func getPreviousVc(_ vc: UIViewController) -> UIViewController? {
        guard let currentPageIndex = pages.firstIndex(of: vc) else {
            return nil
        }
        let previousPageIndex = currentPageIndex - 1
        guard previousPageIndex >= 0 else {
            return nil
        }
        return pages[previousPageIndex]
    }
    
    func getNextVc(_ vc: UIViewController) -> UIViewController? {
        guard let currentPageIndex = pages.firstIndex(of: vc) else {
            return nil
        }
        let nextPageIndex = currentPageIndex + 1
        guard nextPageIndex < pages.count else {
            return nil
        }
        return pages[nextPageIndex]
    }

    func getCurrentPageIndex(for currentViewController: UIViewController) -> Int? {
        pages.firstIndex(of: currentViewController)
    }
    
    func setOnboardingStatus() {
        UserDefaultsAccessor.shared.setOnboardingStatus()
    }
}
