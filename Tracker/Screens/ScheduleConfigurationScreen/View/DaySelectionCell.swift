//
//  DaySelectionCell.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 16.06.2023.
//

import UIKit

final class DaySelectionCell: UITableViewCell {
    lazy var dayLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        view.textColor = .appBlack
        view.textAlignment = .natural
        view.numberOfLines = 0
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.7
        return view
    }()
    
    private func setupSubViews() {
        addSubview(dayLabel)
        
        let constraints = [
            dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            dayLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
