//
//  TrackerScreenHeaderView.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 09.06.2023.
//

import UIKit

final class TrackerScreenHeaderView: UICollectionReusableView {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.textColor = .appBlack
        label.textAlignment = .left
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        return label
    }()
    
    private func setupSubViews() {
        addSubview(titleLabel)
        
        let constraints = [
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init? not implemented")
    }
}
