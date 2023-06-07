//
//  LaunchScreenController.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 07.06.2023.
//

import UIKit

final class LaunchScreenController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    let screenView = LaunchScreenView()
    private var presenter: LaunchScreenPresenter?
    
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

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.presenter = LaunchScreenPresenter(controller: self)
        }
    }
    
    override func viewDidLoad() {
        setupSubViews()
    }
}
