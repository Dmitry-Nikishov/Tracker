//
//  LaunchScreenController.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 07.06.2023.
//

import UIKit

final class LaunchScreenController: StyledScreenController {    

    private var viewModel: LaunchScreenViewModel?
    
    private lazy var logo: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "logo")
        return view
    }()

    private func setupBindings() {
        guard let viewModel = viewModel else { return }
        viewModel.$hasOnboardingBeenAccepted.bind { newValue in
            if newValue {
                UIApplication.shared.windows.first?.rootViewController = AppTabBarController()
            } else {
                UIApplication.shared.windows.first?.rootViewController = OnboardingScreenController(
                    transitionStyle: .scroll,
                    navigationOrientation: .horizontal
                )
            }
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
    
    private func setupSubViews() {
        view.backgroundColor = .appBlue
        view.addSubview(logo)
        
        let constraints = [
            logo.widthAnchor.constraint(equalToConstant: 91),
            logo.heightAnchor.constraint(equalToConstant: 94),
            logo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.viewModel = LaunchScreenViewModel()
            self?.setupBindings()
            self?.viewModel?.checkOnboardingAcceptedFlag()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
    }
}
