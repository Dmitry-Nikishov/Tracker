//
//  ScheduleConfigurationScreenView.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 16.06.2023.
//

import UIKit

protocol ScheduleConfigurationScreenViewDelegate: AnyObject {
    func applySchedule()
}

final class ScheduleConfigurationScreenView: UIView {
    weak var delegate: ScheduleConfigurationScreenViewDelegate?

    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.textColor = .appBlack
        view.textAlignment = .center
        view.numberOfLines = 0
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.7
        view.text = "Расписание"
        return view
    }()

    lazy var daysTableView: UITableView = {
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

    lazy var finishedButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .appBlack
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.setTitleColor(.appWhite, for: .normal)
        view.setTitle("Готово", for: .normal)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.addTarget(nil, action: #selector(finishedButtonTapped), for: .touchUpInside)
        return view
    }()

    private func setupSubViews() {
        addSubview(titleLabel)
        addSubview(daysTableView)
        addSubview(finishedButton)

        let constraints = [
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            daysTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            daysTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            daysTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            daysTableView.bottomAnchor.constraint(
                equalTo: finishedButton.topAnchor,
                constant: -24
            ),
            finishedButton.heightAnchor.constraint(equalToConstant: 60),
            finishedButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            finishedButton.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -20
            ),
            finishedButton.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor
            )
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupSubViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    @objc private func finishedButtonTapped() {
        delegate?.applySchedule()
    }
}
