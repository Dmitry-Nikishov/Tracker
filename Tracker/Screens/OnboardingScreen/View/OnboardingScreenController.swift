//
//  OnboardingScreenController.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 26.06.2023.
//

import UIKit

final class OnboardingScreenController: UIPageViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    private var viewModel: OnboardingScreenViewModel?

    private lazy var pageControl = {
        let view = UIPageControl()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.currentPageIndicatorTintColor = .appBlack
        view.pageIndicatorTintColor = .appBlack.withAlphaComponent(0.3)
        view.backgroundColor = .clear
        view.numberOfPages = 2
        view.isEnabled = false
        return view
    }()
    
    private lazy var continueButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .appBlack
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.setTitleColor(.appWhite, for: .normal)
        view.setTitle("WHAT_TECHNOLOGIES".localized, for: .normal)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.addTarget(
            nil,
            action: #selector(continueButtonClicked),
            for: .touchUpInside
        )
        return view
    }()
    
    private func setupSubViews() {
        view.backgroundColor = .appBlue
        
        view.addSubview(pageControl)
        view.addSubview(continueButton)

        let constraints = [
            continueButton.heightAnchor.constraint(
                equalToConstant: 60
            ),
            continueButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 20
            ),
            continueButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -20
            ),
            continueButton.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -84
            ),
            pageControl.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            pageControl.bottomAnchor.constraint(
                equalTo: continueButton.topAnchor,
                constant: -24
            )
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupModel() {
        viewModel = OnboardingScreenViewModel()
        dataSource = self
        delegate = self
        if let firstPage = viewModel?.getFirstPage() {
            setViewControllers(
                [firstPage],
                direction: .forward,
                animated: true,
                completion: nil
            )
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
        setupModel()
    }
    
    @objc
    private func continueButtonClicked() {
        viewModel?.setOnboardingStatus()
        let window = UIApplication.shared.windows.first
        window?.rootViewController = AppTabBarController()
        window?.makeKeyAndVisible()
    }
}

extension OnboardingScreenController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        viewModel?.getPreviousVc(viewController)
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        viewModel?.getNextVc(viewController)
    }
}

extension OnboardingScreenController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool
    ) {
        if let currentVc = pageViewController.viewControllers?.first,
           let currentPageIndex = viewModel?.getCurrentPageIndex(for: currentVc) {
            pageControl.currentPage = currentPageIndex
        }
    }
}

