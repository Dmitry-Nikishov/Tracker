//
//  ScheduleConfigurationScreenController.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 16.06.2023.
//

import UIKit

protocol ScheduleConfigurationDelegate: AnyObject {
    var alreadySelectedSchedule: [String] { get }
    func updateSchedule(withDays days: [String])
}

final class ScheduleConfigurationScreenController: StyledScreenController {
    let screenView = ScheduleConfigurationScreenView()
    private var presenter: ScheduleConfigurationScreenPresenter?
    weak var delegate: ScheduleConfigurationDelegate?

    convenience init(delegate: ScheduleConfigurationDelegate?) {
        self.init()
        self.delegate = delegate
    }

    private func setupSubViews() {
        view.backgroundColor = .appWhite
        view.addSubview(screenView)
        
        let constraints = [
            screenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            screenView.topAnchor.constraint(equalTo: view.topAnchor),
            screenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            screenView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        screenView.delegate = self
        screenView.daysTableView.dataSource = self
        screenView.daysTableView.delegate = self
        
        presenter = ScheduleConfigurationScreenPresenter(controller: self)
        presenter?.setAlreadySelectedDays(with: delegate?.alreadySelectedSchedule ?? [])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
    }
}

extension ScheduleConfigurationScreenController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.getNumberOfDays() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        presenter?.setupCell(
            tableView: tableView,
            indexPath: indexPath
        ) ?? UITableViewCell()
    }
}

extension ScheduleConfigurationScreenController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension ScheduleConfigurationScreenController: ScheduleConfigurationScreenViewDelegate {
    func applySchedule() {
        delegate?.updateSchedule(withDays: presenter?.getSelectedDays() ?? [])
        dismiss(animated: true)
    }
}
