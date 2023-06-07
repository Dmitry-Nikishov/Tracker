//
//  UserDefaultsAccessor.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 07.06.2023.
//

import Foundation

final class UserDefaultsAccessor {
    static var shared = UserDefaultsAccessor()
    
    private init() {}
    
    private enum Keys: String {
        case onboardingAccepted
    }
    
    private let userDefaults = UserDefaults.standard
    
    private(set) var isOnboardingAccepted: Bool {
        get {
            getUserDefaults(key: .onboardingAccepted, type: Bool.self) ?? false
        }
        
        set {
            setUserDefaults(key: .onboardingAccepted, data: newValue)
        }
    }
    
    private func getUserDefaults<T: Codable>(key: Keys, type: T.Type) -> T? {
        guard let data = userDefaults.data(forKey: key.rawValue),
              let decodedData = try? JSONDecoder().decode(type.self, from: data)
        else {
            return nil
        }
        
        return decodedData
    }
    
    private func setUserDefaults<T: Codable>(key: Keys, data: T) {
        guard let data = try? JSONEncoder().encode(data) else {
            print("Userdefaults set failure")
            return
        }
        
        userDefaults.set(data, forKey: key.rawValue)
    }
    
    func setOnboardingStatus() {
        isOnboardingAccepted = true
    }
}
