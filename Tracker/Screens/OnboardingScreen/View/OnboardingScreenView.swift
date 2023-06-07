//
//  OnboardingScreenView.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 07.06.2023.
//

import UIKit

protocol OnboardingScreenViewDelegate: AnyObject {
    func goToMainScreen()
}

final class OnboardingScreenView: UIView {
    weak var delegate: OnboardingScreenViewDelegate?
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.contentSize = CGSize(
            width: UIScreen.main.bounds.width * 2,
            height: 0
        )
        return view
    }()
    
    private lazy var pageControlView: UIPageControl = {
        let view = UIPageControl()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfPages = 2
        view.isEnabled = false
        view.currentPageIndicatorTintColor = .appBlack
        view.pageIndicatorTintColor = .appBlack.withAlphaComponent(0.3)
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var greetingButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .appBlack
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.setTitleColor(.appWhite, for: .normal)
        view.setTitle("Вот это технологии!", for: .normal)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.addTarget(nil,
                       action: #selector(greetingButtonTappedHandler),
                       for: .touchUpInside)

        return view
    }()
    
    private func setupConstraints() {
        let constraints = [
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            greetingButton.heightAnchor.constraint(equalToConstant: 60),
            greetingButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            greetingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            greetingButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -84),
            pageControlView.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControlView.bottomAnchor.constraint(equalTo: greetingButton.topAnchor, constant: -24)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupSubViews() {
        addSubview(scrollView)
        addSubview(pageControlView)
        addSubview(greetingButton)
        
        setupConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        setupSubViews()
        scrollView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented for OnboardingScreenView")
    }
    
    @objc private func greetingButtonTappedHandler() {
        delegate?.goToMainScreen()
    }
}

extension OnboardingScreenView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / CGFloat(self.scrollView.bounds.width))
        pageControlView.currentPage = currentPage
    }
}

