//
//  LaunchScreenViewModel.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 26.06.2023.
//

import Foundation

final class LaunchScreenViewModel {
    @Observable
    private(set) var hasOnboardingBeenAccepted: Bool = false
    
    func checkOnboardingAcceptedFlag() {
        hasOnboardingBeenAccepted = UserDefaultsAccessor.shared.isOnboardingAccepted
    }
}


