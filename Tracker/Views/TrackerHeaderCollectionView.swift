//
//  HeaderCollectionView.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 24.05.2023.
//

import UIKit

final class TrackerHeaderCollectionView: UICollectionReusableView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 19)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented for HeaderCollectionView")
    }
        
    private func configureSubviews() {
        addSubview(titleLabel)
        
        let constraints = [
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func configureTitle(_ title: String) {
        titleLabel.text = title
    }
}
