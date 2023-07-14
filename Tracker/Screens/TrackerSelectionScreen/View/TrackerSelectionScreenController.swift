//
//  TrackerSelectionScreenController.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 26.06.2023.
//

import UIKit

final class TrackerSelectionScreenController: StyledScreenController {
    private let analyticsService = AnalyticsService()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.textColor = .appBlack
        view.textAlignment = .center
        view.numberOfLines = 0
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.7
        view.text = "TRACKER_CREATION".localized
        return view
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 16
        return view
    }()

    private lazy var habitButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .appBlack
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.setTitleColor(.appWhite, for: .normal)
        view.setTitle("HABIT".localized, for: .normal)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.addTarget(nil, action: #selector(habitButtonClicked), for: .touchUpInside)
        return view
    }()

    private lazy var eventButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .appBlack
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.setTitleColor(.appWhite, for: .normal)
        view.setTitle("NONREGULAR_EVENT".localized, for: .normal)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.addTarget(nil, action: #selector(eventButtonClicked), for: .touchUpInside)
        return view
    }()

    private func setupSubView() {
        view.backgroundColor = .appWhite

        view.addSubview(titleLabel)
        stackView.addArrangedSubview(habitButton)
        stackView.addArrangedSubview(eventButton)
        view.addSubview(stackView)

        let constraints = [
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            eventButton.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubView()
        
        analyticsService.sendReport(
            event: AppConstants.YandexMobileMetrica.Events.click,
            params: [
                "screen": AppConstants.YandexMobileMetrica.Screens.trackers,
                "item": AppConstants.YandexMobileMetrica.Items.addTrack
            ]
        )
        
        analyticsService.sendReport(
            event: AppConstants.YandexMobileMetrica.Events.open,
            params: [
                "screen": AppConstants.YandexMobileMetrica.Screens.trackerSelection
            ]
        )
    }

    @objc private func habitButtonClicked() {
        analyticsService.sendReport(
            event: AppConstants.YandexMobileMetrica.Events.click,
            params: [
                "screen": AppConstants.YandexMobileMetrica.Screens.trackerSelection,
                "item": AppConstants.YandexMobileMetrica.Items.habit
            ]
        )

        present(HabitCreationScreenController(), animated: true)
    }
    
    @objc private func eventButtonClicked() {
        analyticsService.sendReport(
            event: AppConstants.YandexMobileMetrica.Events.click,
            params: [
                "screen": AppConstants.YandexMobileMetrica.Screens.trackerSelection,
                "item": AppConstants.YandexMobileMetrica.Items.event
            ]
        )

        present(HabitCreationScreenController(isNonRegularEvent: true), animated: true)
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        analyticsService.sendReport(
            event: AppConstants.YandexMobileMetrica.Events.close,
            params: [
                "screen": AppConstants.YandexMobileMetrica.Screens.trackerSelection
            ]
        )
    }

}

