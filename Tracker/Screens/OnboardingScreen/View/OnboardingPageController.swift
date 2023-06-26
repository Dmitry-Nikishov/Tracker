//
//  OnboardingPageController.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 26.06.2023.
//

import UIKit

final class OnboardingPageController: StyledScreenController {
    private lazy var backgroundImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var infoLabel = {
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
    
    convenience init(
        text: String,
        backgroundImage: UIImage
    ) {
        self.init()
        infoLabel.text = text
        backgroundImageView.image = backgroundImage
    }

    private func setupSubViews() {
        view.backgroundColor = .appBlue
        
        view.addSubview(backgroundImageView)
        view.addSubview(infoLabel)
        
        let constraints = [
            backgroundImageView.widthAnchor.constraint(
                equalToConstant: UIScreen.main.bounds.width
            ),
            backgroundImageView.heightAnchor.constraint(
                equalToConstant: UIScreen.main.bounds.height
            ),
            infoLabel.leadingAnchor.constraint(
                equalTo: backgroundImageView.leadingAnchor, constant: 16
            ),
            infoLabel.trailingAnchor.constraint(
                equalTo: backgroundImageView.trailingAnchor,
                constant: -16
            ),
            infoLabel.bottomAnchor.constraint(
                equalTo: backgroundImageView.bottomAnchor,
                constant: -304)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
    }
}

