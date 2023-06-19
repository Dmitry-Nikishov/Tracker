//
//  TrackerSelectionScreenController.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 09.06.2023.
//

import UIKit

final class TrackerSelectionScreenController: StyledScreenController {
    private let screenView = TrackerSelectionScreenView()
    
    private func setupConstraints() {
        let constraints = [
            screenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            screenView.topAnchor.constraint(equalTo: view.topAnchor),
            screenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            screenView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appWhite
        view.addSubview(screenView)
        setupConstraints()
        screenView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let topVc = UIApplication.shared.windows.filter({
            $0.isKeyWindow
        }
        ).first?.rootViewController {
            let destinationVc =
            topVc.children.first?.children.first as? TrackersScreenController
            destinationVc?.updateCollectionView()
        }
    }
}

extension TrackerSelectionScreenController: TrackerSelectionScreenViewDelegate {
    func toHabit() {
        present(HabitCreationScreenController(), animated: true)
    }
    
    func toEvent() {
        present(
            HabitCreationScreenController(isNonRegularEvent: true),
            animated: true
        )
    }
}
