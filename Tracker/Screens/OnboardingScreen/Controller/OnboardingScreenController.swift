//
//  OnboardingScreenController.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 07.06.2023.
//

import UIKit

final class OnboardingScreenController: StyledScreenController {    
    let screenView = OnboardingScreenView()
    private var presenter: OnboardingScreenPresenter?
    
    private func setupConstraints() {
        let constraints = [
            screenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            screenView.topAnchor.constraint(equalTo: view.topAnchor),
            screenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            screenView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupSubViews() {
        view.backgroundColor = .appBlue
        view.addSubview(screenView)
        
        setupConstraints()
        presenter = OnboardingScreenPresenter(controller: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
    }
    
}
