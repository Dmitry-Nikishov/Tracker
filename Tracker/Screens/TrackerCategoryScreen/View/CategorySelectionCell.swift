//
//  CategorySelectionCell.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 16.06.2023.
//

import UIKit

final class CategorySelectionCell: UITableViewCell {
    lazy var categoryLabel: UILabel = {
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
        addSubview(categoryLabel)
        
        let constraints = [
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            categoryLabel.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            categoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -41),
            categoryLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -26)
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

