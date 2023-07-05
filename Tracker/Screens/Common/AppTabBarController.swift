//
//  AppTabBarController.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 19.06.2023.
//

import UIKit

final class AppTabBarController: UITabBarController {

    private func configureTabItem(
        controller: UIViewController,
        title: String? = nil,
        andImage image: UIImage
    ) -> UIViewController {
        let tab = controller
        let tabBarItem = UITabBarItem(
            title: title,
            image: image,
            selectedImage: nil
        )
        tab.tabBarItem = tabBarItem
        return tab
    }
    
    private func setupSubViews() {
        tabBar.backgroundColor = .appWhite
        let trackersController = NavigationController(
            rootViewController: TrackersScreenController()
        )
        let statisticsController = NavigationController(
            rootViewController: TrackersScreenController()
        )
        self.viewControllers = [
            configureTabItem(
                controller: trackersController,
                title: "TRACKERS".localized,
                andImage: UIImage(named: "TrackerTabBarIcon") ?? UIImage()
            ),
            configureTabItem(
                controller: statisticsController,
                title: "STATISTICS".localized,
                andImage: UIImage(named: "StatisticsTabBarIcon") ?? UIImage()
            )
        ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSubViews()
    }
}

