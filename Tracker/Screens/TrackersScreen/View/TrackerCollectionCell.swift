//
//  TrackerCollectionCell.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 09.06.2023.
//

import UIKit

protocol TrackerCollectionCellDelegate: AnyObject {
    func doTask(trackerId: UUID)
}

final class TrackerCollectionCell: UICollectionViewCell {
    weak var delegate: TrackerCollectionCellDelegate?
    var trackerId: UUID?
    
    lazy var taskArea: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var taskLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .appBlack
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        return label
    }()
    
    lazy var taskName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .appWhite
        label.textAlignment = .natural
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        return label
    }()
    
    lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .appBlack
        label.textAlignment = .natural
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        return label
    }()
    
    lazy var counterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .appBlack
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.appWhite, for: .normal)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.layer.cornerRadius = 17
        button.layer.masksToBounds = true
        button.tintColor = .appWhite
        button.addTarget(
            nil,
            action: #selector(counterButtonClicked),
            for: .touchUpInside
        )
        return button
    }()
    
    private func setupSubViews() {
        taskArea.addSubview(taskLabel)
        taskArea.addSubview(taskName)
        
        self.addSubview(taskArea)
        self.addSubview(counterLabel)
        self.addSubview(counterButton)
        
        let constraints = [
            taskArea.heightAnchor.constraint(equalToConstant: 90),
            taskArea.leadingAnchor.constraint(equalTo: leadingAnchor),
            taskArea.topAnchor.constraint(equalTo: topAnchor),
            taskArea.trailingAnchor.constraint(equalTo: trailingAnchor),
            taskArea.widthAnchor.constraint(equalToConstant: 24),
            taskArea.heightAnchor.constraint(equalTo: taskLabel.widthAnchor, multiplier: 1),
            taskArea.leadingAnchor.constraint(equalTo: taskArea.leadingAnchor, constant: 12),
            taskArea.topAnchor.constraint(equalTo: taskArea.topAnchor, constant: 12),
            taskName.leadingAnchor.constraint(equalTo: taskArea.leadingAnchor, constant: 12),
            taskName.topAnchor.constraint(
                greaterThanOrEqualTo: taskArea.topAnchor,
                constant: 44
            ),
            taskName.trailingAnchor.constraint(equalTo: taskArea.trailingAnchor, constant: -12),
            taskName.bottomAnchor.constraint(equalTo: taskArea.bottomAnchor, constant: -12),
            counterButton.widthAnchor.constraint(equalToConstant: 34),
            counterButton.heightAnchor.constraint(
                equalTo: counterButton.widthAnchor,
                multiplier: 1
            ),
            counterButton.topAnchor.constraint(
                equalTo: taskArea.bottomAnchor,
                constant: 8
            ),
            counterButton.trailingAnchor.constraint(
                equalTo: taskArea.trailingAnchor,
                constant: -12
            ),
            counterLabel.leadingAnchor.constraint(
                equalTo: taskArea.leadingAnchor,
                constant: 12
            ),
            counterLabel.centerYAnchor.constraint(
                equalTo: counterButton.centerYAnchor
            )
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("required init not implemented for TrackerCollectionCell")
    }
    
    @objc private func counterButtonClicked() {
        guard let id = trackerId else { return }
        delegate?.doTask(trackerId: id)
    }
}
