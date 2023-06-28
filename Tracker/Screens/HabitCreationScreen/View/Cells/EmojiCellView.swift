//
//  EmojiView.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 14.06.2023.
//

import UIKit

final class EmojiCellView: UICollectionViewCell {
    lazy var frameView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .appLightGray
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.isHidden = true
        return view
    }()
    
    lazy var emojiIconLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        view.textColor = .appBlack
        view.textAlignment = .center
        view.numberOfLines = 0
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.7
        return view
    }()
    
    private func setupSubViews() {
        addSubview(frameView)
        addSubview(emojiIconLabel)
        
        let constraints = [
            frameView.leadingAnchor.constraint(equalTo: leadingAnchor),
            frameView.topAnchor.constraint(equalTo: topAnchor),
            frameView.trailingAnchor.constraint(equalTo: trailingAnchor),
            frameView.bottomAnchor.constraint(equalTo: bottomAnchor),
            emojiIconLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emojiIconLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
