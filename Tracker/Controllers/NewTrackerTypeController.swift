//
//  NewTrackerTypeController.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 24.05.2023.
//

import UIKit

final class NewTrackerTypeViewController: UIViewController {
    weak var delegate: TrackerCategoryAddable?
    
    private let categories: [TrackerCategory]
    
    private lazy var controllerTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.text = "Создание трекера"
        label.textColor = .appBlack
        return label
    }()
    
    private let trackerCategoriesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var habitCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Привычка", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.appWhite, for: .normal)
        button.backgroundColor = .appBlack
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.addTarget(
            self,
            action: #selector(newHabitTapped),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var eventCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Нерегулярные событие", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.appWhite, for: .normal)
        button.backgroundColor = .appBlack
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.addTarget(
            self,
            action: #selector(newEventTapped),
            for: .touchUpInside
        )
        return button
    }()
    
    init(categories: [TrackerCategory]) {
        self.categories = categories
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented for NewTrackerTypeViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }
    
    private func configureSubviews() {
        view.backgroundColor = .appWhite
        
        view.addSubview(controllerTitleLabel)
        view.addSubview(trackerCategoriesStackView)
        
        trackerCategoriesStackView.addArrangedSubview(habitCategoryButton)
        trackerCategoriesStackView.addArrangedSubview(eventCategoryButton)
        
        let constraints = [
            controllerTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            controllerTitleLabel.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            
            habitCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            eventCategoryButton.heightAnchor.constraint(equalTo: habitCategoryButton.heightAnchor),
            
            trackerCategoriesStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            trackerCategoriesStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            trackerCategoriesStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
        
    @objc private func newHabitTapped() {
        let vc = NewTrackerViewController(trackerType: .habit)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc private func newEventTapped() {
        let vc = NewTrackerViewController(trackerType: .event)
        vc.delegate = self
        present(vc, animated: true)
    }
}

extension NewTrackerTypeViewController: TrackerCategoryAddable {
    func addNewTrackerCategory(_ category: TrackerCategory) {
        delegate?.addNewTrackerCategory(category)
        dismiss(animated: true)
    }
}
