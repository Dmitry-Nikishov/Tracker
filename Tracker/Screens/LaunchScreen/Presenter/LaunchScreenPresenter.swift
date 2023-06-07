//
//  LaunchScreenPresenter.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 07.06.2023.
//

import UIKit

final class LaunchScreenPresenter {
    private weak var controller: LaunchScreenController?
    
    private func showController() {
        let shouldTabBarControllerBeShown = UserDefaultsAccessor.shared.isOnboardingAccepted
        
        UIApplication.shared.windows.first?.rootViewController =
        shouldTabBarControllerBeShown ?
        AppMainTabBarController() :
        OnboardingScreenController()

        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    init(controller: LaunchScreenController? = nil) {
        self.controller = controller
        showController()
    }
}
