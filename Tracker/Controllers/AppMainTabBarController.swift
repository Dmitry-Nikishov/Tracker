//
//  AppMainTabBarController.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 23.05.2023.
//

import UIKit

final class AppMainTabBarController: UITabBarController {
    private typealias ViewControllerWithIconName =
    (vc: UIViewController, iconName: String, barTitle: String)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupController()
    }
    
    private func setupController() {
        tabBar.backgroundColor = .appWhite
        
        let controllerContent = createControllerContent()
        let iconsName = controllerContent.map{$0.iconName}
        let barTitles = controllerContent.map{$0.barTitle}
        
        self.viewControllers = controllerContent.map{$0.vc}
        
        self.viewControllers?.enumerated().forEach {
            $1.tabBarItem.image = UIImage(systemName: iconsName[$0])
            $1.tabBarItem.title = barTitles[$0]
        }
    }
    
    private func createControllerContent() -> [ViewControllerWithIconName] {
        [
            (vc: UINavigationController(rootViewController: TrackersViewController()),
             iconName: "record.circle.fill",
             barTitle: "Трекеры"),
            
            (vc: UINavigationController(rootViewController: StatisticViewController()),
             iconName: "hare.fill",
             barTitle: "Статистика")
        ]
    }

}
