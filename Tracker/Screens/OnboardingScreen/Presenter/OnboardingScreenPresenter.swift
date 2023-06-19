//
//  OnboardingScreenPresenter.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 07.06.2023.
//

import UIKit

final class OnboardingScreenPresenter {
    private weak var controller: OnboardingScreenController?
    
    private func setupScrollPage(text: String, pageId: Int) {
        let scrollViewPage = UIView()
        scrollViewPage.backgroundColor = .clear
        scrollViewPage.frame = CGRect(x: UIScreen.main.bounds.width * CGFloat(pageId),
                                      y: 0,
                                      width: UIScreen.main.bounds.width,
                                      height: UIScreen.main.bounds.height)
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        if pageId == 0 {
            imageView.image = UIImage(named: "OnboardingFirstPage")
        } else {
            imageView.image = UIImage(named: "OnboardingSecondPage")
        }
        scrollViewPage.addSubview(imageView)
        
        let imageViewConstraints = [
            imageView.widthAnchor.constraint(
                equalToConstant: UIScreen.main.bounds.width
            ),
            imageView.heightAnchor.constraint(
                equalToConstant: UIScreen.main.bounds.height
            )
        ]
        NSLayoutConstraint.activate(imageViewConstraints)
            
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .appBlack
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.text = text

        scrollViewPage.addSubview(label)
            
        let labelConstraints = [
            label.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -304)
        ]
        NSLayoutConstraint.activate(labelConstraints)
            
        controller?.screenView.scrollView.addSubview(scrollViewPage)
    }
    
    private func setupSubViews() {
        setupScrollPage(
            text: "Отслеживайте только то, что хотите",
            pageId: 0 )
        
        setupScrollPage(
            text: "Даже если это не литры воды и йога",
            pageId: 1)
    }
    
    init(controller: OnboardingScreenController? = nil) {
        self.controller = controller
        self.controller?.screenView.delegate = self
        setupSubViews()
    }
}

extension OnboardingScreenPresenter: OnboardingScreenViewDelegate {
    func goToMainScreen() {
        UserDefaultsAccessor.shared.setOnboardingStatus()
        UIApplication.shared.windows.first?.rootViewController = AppTabBarController()
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
