//
//  StatisticsScreenController.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 04.07.2023.
//

import UIKit

final class StatisticsScreenController: UIViewController {
    private var viewModel: StatisticsScreenViewModel?
    private let analyticsService = AnalyticsService()

    private lazy var dummyDataImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "noDataToAnalyze")
        return view
    }()
    
    private lazy var dummyDataLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        view.textColor = .appBlack
        view.textAlignment = .center
        view.numberOfLines = 0
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.7
        view.text = "NOTHING_TO_ANALYZE".localized
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 12
        view.layer.cornerRadius = 0
        return view
    }()
    
    private lazy var stackViewForBestPeriod: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 7
        view.layer.cornerRadius = 12
        return view
    }()

    private lazy var labelForBestPeriodCount: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        view.textColor = .appBlack
        view.textAlignment = .left
        view.numberOfLines = 0
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.7
        view.text = "-"
        return view
    }()

    private lazy var labelForBestPeriod: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        view.textColor = .appBlack
        view.textAlignment = .left
        view.numberOfLines = 0
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.7
        view.text = "BEST_PERIOD".localized
        return view
    }()

    private lazy var stackViewForIdealDays: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 7
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var labelForIdealDaysCount: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        view.textColor = .appBlack
        view.textAlignment = .left
        view.numberOfLines = 0
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.7
        view.text = "-"
        return view
    }()
    
    private lazy var labelForIdealDays: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        view.textColor = .appBlack
        view.textAlignment = .left
        view.numberOfLines = 0
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.7
        view.text = "IDEAL_DAYS".localized
        return view
    }()

    private lazy var stackViewForCompletedTrackers: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 7
        view.layer.cornerRadius = 12
        return view
    }()

    private lazy var labelForCompletedTrackersCount: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        view.textColor = .appBlack
        view.textAlignment = .left
        view.numberOfLines = 0
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.7
        view.text = "-"
        return view
    }()
    
    private lazy var labelForCompletedTrackers: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        view.textColor = .appBlack
        view.textAlignment = .left
        view.numberOfLines = 0
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.7
        view.text = "TRACKERS_COMPLETED".localized
        return view
    }()
    
    private lazy var stackViewForAverage: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 7
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var labelForAverageValueCount: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        view.textColor = .appBlack
        view.textAlignment = .left
        view.numberOfLines = 0
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.7
        view.text = "-"
        return view
    }()
    
    private lazy var labelForAverageValue: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        view.textColor = .appBlack
        view.textAlignment = .left
        view.numberOfLines = 0
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.7
        view.text = "AVERAGE_VALUE".localized
        return view
    }()

    private func setupSubViews() {
        view.backgroundColor = .appWhite

        view.addSubview(dummyDataImage)
        view.addSubview(dummyDataLabel)
        
        stackViewForBestPeriod.addArrangedSubview(labelForBestPeriodCount)
        stackViewForBestPeriod.addArrangedSubview(labelForBestPeriod)
        stackView.addArrangedSubview(stackViewForBestPeriod)
        
        stackViewForIdealDays.addArrangedSubview(labelForIdealDaysCount)
        stackViewForIdealDays.addArrangedSubview(labelForIdealDays)
        stackView.addArrangedSubview(stackViewForIdealDays)
        
        stackViewForCompletedTrackers.addArrangedSubview(labelForCompletedTrackersCount)
        stackViewForCompletedTrackers.addArrangedSubview(labelForCompletedTrackers)
        stackView.addArrangedSubview(stackViewForCompletedTrackers)

        stackViewForAverage.addArrangedSubview(labelForAverageValueCount)
        stackViewForAverage.addArrangedSubview(labelForAverageValue)
        stackView.addArrangedSubview(stackViewForAverage)
        
        view.addSubview(stackView)

        let constraints = [
            dummyDataImage.heightAnchor.constraint(equalToConstant: 80),
            dummyDataImage.widthAnchor.constraint(equalTo: dummyDataImage.heightAnchor),
            dummyDataImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dummyDataImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            dummyDataLabel.topAnchor.constraint(equalTo: dummyDataImage.bottomAnchor, constant: 8),
            dummyDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 396),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ]
        NSLayoutConstraint.activate(constraints)
        
        modifyStatisticsHiddenState(isToBeShown: false)
        viewModel = StatisticsScreenViewModel()
        setupBindings()

        analyticsService.sendReport(
            event: AppConstants.YandexMobileMetrica.Events.open,
            params: [
                "screen": AppConstants.YandexMobileMetrica.Screens.statistics
            ]
        )
    }

    private func modifyStatisticsHiddenState(isToBeShown: Bool) {
        if isToBeShown {
            dummyDataImage.isHidden = true
            dummyDataLabel.isHidden = true
            stackView.isHidden = false
        } else {
            dummyDataImage.isHidden = false
            dummyDataLabel.isHidden = false
            stackView.isHidden = true
        }
    }
    
    private func displayStatistics() {
        labelForBestPeriodCount.text = viewModel?.getBestPeriod() ?? "-"
        labelForIdealDaysCount.text = viewModel?.getNumberOfIdealDays() ?? "-"
        labelForCompletedTrackersCount.text = viewModel?.getNumberOfCompletedTrackers() ?? "-"
        labelForAverageValueCount.text = viewModel?.getAverage() ?? "-"
    }
    
    private func setupBindings() {
        guard let viewModel = viewModel else { return }
        viewModel.$shouldStatisticsBeShown.bind { [weak self] newValue in
            if newValue {
                self?.displayStatistics()
                self?.modifyStatisticsHiddenState(isToBeShown: true)
            } else {
                self?.modifyStatisticsHiddenState(isToBeShown: false)
            }
        }
    }
    
    private func setupGradientBorder(
        view: UIView,
        colors: [UIColor],
        isVertical: Bool
    ) {
        view.layer.masksToBounds = true

        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: CGPoint.zero, size: view.bounds.size)
        gradient.colors = colors.map({ (color) -> CGColor in
            color.cgColor
        })

        if isVertical {
            gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        } else {
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        }

        let shape = CAShapeLayer()
        shape.lineWidth = 1.0
        shape.path = UIBezierPath(roundedRect: gradient.frame.insetBy(dx: 1.0, dy: 1.0),
                                  cornerRadius: view.layer.cornerRadius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape

        view.layer.addSublayer(gradient)
    }

    private func setupChildStackViews() {
        let stacks = [
            stackViewForBestPeriod,
            stackViewForIdealDays,
            stackViewForCompletedTrackers,
            stackViewForAverage
        ]
        
        stacks.forEach { item in
            item.layoutMargins = UIEdgeInsets(
                top: 12,
                left: 12,
                bottom: 12,
                right: 12
            )
            item.isLayoutMarginsRelativeArrangement = true
            setupGradientBorder(
                view: item,
                colors: [
                    .appGradientRed,
                    .appGradientSky,
                    .appGradientBlue
                ],
                isVertical: false
            )
        }
    }
    
    override func viewDidLoad() {
        setupSubViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupChildStackViews()
        viewModel?.checkStoreForData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        analyticsService.sendReport(
            event: AppConstants.YandexMobileMetrica.Events.close,
            params: [
                "screen": AppConstants.YandexMobileMetrica.Screens.statistics
            ]
        )
    }
}


