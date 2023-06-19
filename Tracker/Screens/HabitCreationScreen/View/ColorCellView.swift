//
//  ColorView.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 14.06.2023.
//

import UIKit

final class ColorCellView: UICollectionViewCell {
    lazy var frameView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .appWhite
        view.layer.cornerRadius = 11
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.clear.cgColor
        return view
    }()
    
    lazy var colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    private func setupSubViews() {
        addSubview(frameView)
        addSubview(colorView)
        
        let constraints = [
            frameView.leadingAnchor.constraint(equalTo: leadingAnchor),
            frameView.topAnchor.constraint(equalTo: topAnchor),
            frameView.trailingAnchor.constraint(equalTo: trailingAnchor),
            frameView.bottomAnchor.constraint(equalTo: bottomAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.heightAnchor.constraint(equalTo: colorView.widthAnchor, multiplier: 1),
            colorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) not implemented here")
    }
}
