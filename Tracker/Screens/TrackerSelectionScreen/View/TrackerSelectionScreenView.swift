//
//  TrackerSelectionScreenView.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 09.06.2023.
//

import UIKit

protocol TrackerSelectionScreenViewDelegate: AnyObject {
    func toHabit()
    func toEvent()
}


final class TrackerSelectionScreenView: UIView {
    weak var delegate: TrackerSelectionScreenViewDelegate?
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.textColor = .appBlack
        view.textAlignment = .center
        view.numberOfLines = 0
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.7
        view.text = "Создание трекера"
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
        view.setTitle("Привычка", for: .normal)
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
        view.setTitle("Нерегулярное событие", for: .normal)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.addTarget(nil, action: #selector(eventButtonClicked), for: .touchUpInside)
        return view
    }()
    
    @objc private func habitButtonClicked() {
        delegate?.toHabit()
    }
    
    @objc private func eventButtonClicked() {
        delegate?.toEvent()
    }

    private func setupSubviews() {
        addSubview(titleLabel)
        stackView.addArrangedSubview(habitButton)
        stackView.addArrangedSubview(eventButton)
        addSubview(stackView)
        
        let constraints = [
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            eventButton.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented for TrackerSelectionScreenView")
    }
}
