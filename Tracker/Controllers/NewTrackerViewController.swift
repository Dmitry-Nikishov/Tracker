//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 24.05.2023.
//

import UIKit

final class NewTrackerViewController: UIViewController {
    weak var delegate: TrackerCategoryAddable?
    
    private let trackerType: TrackerType
    private var heightTableView: CGFloat = 74
    private var currentCategory: String? = "Новая категория"
    private var trackerText = ""
    private var schedule: [WeekDay] = []
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .appBlack
        label.text = trackerType.labelText
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите название трекера"
        textField.clearButtonMode = .whileEditing
        let leftInsetView = UIView(frame: CGRect(x: 0, y: 0, width: 17, height: 30))
        textField.leftView = leftInsetView
        textField.leftViewMode = .always
        textField.backgroundColor = .appBackground
        textField.layer.cornerRadius = 16
        textField.clipsToBounds = true
        textField.delegate = self
        textField.addTarget(
            self,
            action: #selector(textFieldChangedHandler(textField:)),
            for: .editingChanged
        )
        return textField
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .appBackground
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = .appGray
        tableView.isScrollEnabled = false
        
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: String(describing: UITableViewCell.self)
        )
        tableView.delegate = self
        tableView.dataSource = self

        return tableView
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.appRed, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .appWhite
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.appRed.cgColor
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.appWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .appGray
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    init(trackerType: TrackerType) {
        self.trackerType = trackerType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented for NewTrackerViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }
    
    private func configureSubviews() {
        view.backgroundColor = .appWhite
        
        view.addSubview(titleLabel)
        view.addSubview(textField)
        view.addSubview(tableView)
        view.addSubview(saveButton)
        view.addSubview(cancelButton)
        
        heightTableView = trackerType.heightForTableView
        
        let constraints = [
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32),
            
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: heightTableView),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cancelButton.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: -8),
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            saveButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor),
            saveButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func shouldSaveButtonBeEnabled() -> Bool {
        switch trackerType {
        case .habit:
            return textField.text?.isEmpty == false &&
                   !schedule.isEmpty
        case .event:
            return textField.text?.isEmpty == false
        }
    }
    
    private func enableSaveButtonIf(condition: Bool) {
        if condition {
            saveButton.backgroundColor = .appBlack
            saveButton.isEnabled = true
        } else {
            saveButton.backgroundColor = .appGray
            saveButton.isEnabled = false
        }
    }
    
    private func createBasicTableViewCell() -> UITableViewCell {
        let cell = UITableViewCell(
            style: .subtitle,
            reuseIdentifier: String(describing: UITableViewCell.self)
        )
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
        cell.detailTextLabel?.textColor = .appGray
        return cell
    }
        
    @objc private func textFieldChangedHandler(textField: UITextField) {
        let saveButtonEnabledCondition = shouldSaveButtonBeEnabled()
        enableSaveButtonIf(condition: saveButtonEnabledCondition)
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        trackerText = textField.text ?? ""
        dismiss(animated: true) {
            self.delegate?.addNewTrackerCategory(
                TrackerCategory(
                    title: "Новая категория",
                    trackers: [
                        Tracker(
                            id: UUID(),
                            name: self.trackerText,
                            emoji: "❤️",
                            color: .appGreen,
                            schedule: self.schedule)
                    ]
                )
            )
        }
    }
}

extension NewTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackerType.numberOfRowsForTableView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = createBasicTableViewCell()
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Категория"
            cell.detailTextLabel?.text = currentCategory
        case 1:
            cell.textLabel?.text = "Расписание"
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension NewTrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        trackerText = textField.text ?? ""
        textField.resignFirstResponder()
        return true
    }        
}

extension NewTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let vc = ScheduleViewController()
            vc.delegate = self
            present(vc, animated: true)
        }
    }
}

extension NewTrackerViewController: ScheduleViewControllerDelegate {
    func addNewSchedule(_ newSchedule: [WeekDay]) {
        schedule = newSchedule
        
        let saveButtonEnableCondition = shouldSaveButtonBeEnabled()
        enableSaveButtonIf(condition: saveButtonEnableCondition)
    }
}
