//
//  ScheduleConfigurationScreenController.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 26.06.2023.
//

import UIKit

protocol ScheduleConfigurationDelegate: AnyObject {
    var alreadySelectedSchedule: [String] { get }
    func updateSchedule(withDays days: [String])
}

final class ScheduleConfigurationScreenController: StyledScreenController {
    private var viewModel: ScheduleConfigurationScreenViewModel?
    weak var delegate: ScheduleConfigurationDelegate?
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
        view.text = "SCHEDULE".localized
        return view
    }()

    private lazy var daysTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.backgroundColor = .appWhite
        view.showsVerticalScrollIndicator = false
        view.register(
            DaySelectionCell.self,
            forCellReuseIdentifier: String(describing: DaySelectionCell.self)
        )
        return view
    }()

    private lazy var finishedButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .appBlack
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.setTitleColor(.appWhite, for: .normal)
        view.setTitle("DONE".localized, for: .normal)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.addTarget(nil, action: #selector(finishedButtonTapped), for: .touchUpInside)
        return view
    }()

    convenience init(delegate: ScheduleConfigurationDelegate?) {
        self.init()
        self.delegate = delegate
    }
    
    private func setupSubViews() {
        view.backgroundColor = .appWhite
     
        view.addSubview(titleLabel)
        view.addSubview(daysTableView)
        view.addSubview(finishedButton)

        let constraints = [
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            daysTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            daysTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            daysTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            daysTableView.bottomAnchor.constraint(equalTo: finishedButton.topAnchor, constant: -24),
            finishedButton.heightAnchor.constraint(equalToConstant: 60),
            finishedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            finishedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            finishedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupModel() {
        viewModel = ScheduleConfigurationScreenViewModel()
        viewModel?.setAlreadySelectedDays(
            with: delegate?.alreadySelectedSchedule ?? []
        )
        
        daysTableView.dataSource = self
        daysTableView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubViews()
        setupModel()
        
        analyticsService.sendReport(
            event: AppConstants.YandexMobileMetrica.Events.open,
            params: [
                "screen": AppConstants.YandexMobileMetrica.Screens.scheduleConfiguration
            ]
        )
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        analyticsService.sendReport(
            event: AppConstants.YandexMobileMetrica.Events.close,
            params: [
                "screen": AppConstants.YandexMobileMetrica.Screens.scheduleConfiguration
            ]
        )
    }
    
    @objc private func finishedButtonTapped() {
        analyticsService.sendReport(
            event: AppConstants.YandexMobileMetrica.Events.click,
            params: [
                "screen": AppConstants.YandexMobileMetrica.Screens.scheduleConfiguration,
                "item": AppConstants.YandexMobileMetrica.Items.confirmSchedule
            ]
        )
        delegate?.updateSchedule(withDays: viewModel?.getSelectedDays() ?? [])
        dismiss(animated: true)
    }
}

extension ScheduleConfigurationScreenController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.getNumberOfDays() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModel?.setupCell(
            tableView: tableView,
            indexPath: indexPath) ?? UITableViewCell()
    }
}

extension ScheduleConfigurationScreenController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

