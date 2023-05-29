//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 24.05.2023.
//

import UIKit

protocol TrackerCollectionViewCellDelegate: AnyObject {
    func addButtonTapped(cell: TrackerCollectionViewCell)
}

final class TrackerCollectionViewCell: UICollectionViewCell {
    weak var delegate: TrackerCollectionViewCellDelegate?
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .appRed
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var numberOfDayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .appBlack
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "0 Дней"
        return label
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .appRed
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 17
        button.addTarget(
            self,
            action: #selector(addButtonTapped),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .appBackground
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.text = "🍏"
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .appWhite
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "Поливать растения"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError(
            "init(coder:) not implemented for TrackerCollectionViewCell"
        )
    }
            
    private func configureSubviews() {
        contentView.addSubview(colorView)
        contentView.addSubview(numberOfDayLabel)
        contentView.addSubview(plusButton)
        
        colorView.addSubview(emojiLabel)
        colorView.addSubview(nameLabel)
        
        let gap: CGFloat = 12
        
        let constraints = [
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -42),

            numberOfDayLabel.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            numberOfDayLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: gap
            ),
            plusButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -gap
            ),
            plusButton.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 8),
            plusButton.heightAnchor.constraint(equalToConstant: 34),
            plusButton.widthAnchor.constraint(equalToConstant: 34),

            emojiLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: gap),
            emojiLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: gap),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            
            nameLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: gap),
            nameLabel.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -gap),
            nameLabel.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -gap)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func configureCell(with item: Tracker) {
        nameLabel.text = item.text
        emojiLabel.text = item.emoji
        colorView.backgroundColor = item.color
        plusButton.backgroundColor = item.color
    }
    
    func configureRecord(daysCount: Int, isFinishedToday: Bool) {
        plusButton.setTitle(isFinishedToday ? "✓" : "+", for: .normal)
        plusButton.layer.opacity = isFinishedToday ? 0.3 : 1
        numberOfDayLabel.text = "\(daysCount) Дней"
    }

    @objc private func addButtonTapped() {
        delegate?.addButtonTapped(cell: self)
    }
}

