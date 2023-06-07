//
//  LaunchScreenView.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 07.06.2023.
//

import UIKit

final class LaunchScreenView: UIView {
    private lazy var logo: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "logo")
        return view
    }()
    
    private func setupConstraints() {
        let constraints = [
            logo.widthAnchor.constraint(equalToConstant: 91),
            logo.heightAnchor.constraint(equalToConstant: 94),
            logo.centerYAnchor.constraint(equalTo: centerYAnchor),
            logo.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupSubViews() {
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubview(logo)
        setupConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented for LaunchScreenView")
    }
}
