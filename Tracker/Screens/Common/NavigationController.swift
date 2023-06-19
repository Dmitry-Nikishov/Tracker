//
//  NavigationController.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 09.06.2023.
//

import UIKit

protocol DateUpdateDelegate: AnyObject {
    func updateDate(date: Date)
}

final class NavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        topViewController?.preferredStatusBarStyle ?? .default
    }
    
    weak var dateUpdateDelegate: DateUpdateDelegate?
    
    private func setupTrackersScreenController(viewController: UIViewController) {
        if viewController is TrackersScreenController {
            navigationBar.topItem?.title = "Трекеры"
            navigationBar.topItem?.leftBarButtonItem =
                UIBarButtonItem(
                    barButtonSystemItem: .add,
                    target: nil,
                    action: #selector(addClicked)
                )
            
            let datePicker = UIDatePicker()
            datePicker.translatesAutoresizingMaskIntoConstraints = false
            datePicker.layer.masksToBounds = true
            datePicker.layer.cornerRadius = 8
            datePicker.backgroundColor = .appLightGray.withAlphaComponent(0.12)
            datePicker.tintColor = .blue
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .compact
            datePicker.locale = Locale(identifier: "ru")
            datePicker.addTarget(
                nil,
                action: #selector(dateSelected(_:)),
                for: .valueChanged
            )
            
            navigationBar.addSubview(datePicker)
            let constraints = [
                datePicker.rightAnchor.constraint(
                    equalTo: navigationBar.rightAnchor,
                    constant: -16
                ),
                datePicker.bottomAnchor.constraint(
                    equalTo: navigationBar.bottomAnchor,
                    constant: -11
                ),
                datePicker.heightAnchor.constraint(
                    equalToConstant: 34
                )
            ]
            
            NSLayoutConstraint.activate(constraints)
        }
    }
    
    private func setupInternals(viewController: UIViewController) {
        navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.appBlack
        ]
        navigationBar.tintColor = .appBlack
        navigationBar.prefersLargeTitles = true
        
        setupTrackersScreenController(viewController: viewController)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setupInternals(viewController: rootViewController)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented for NavigationController")
    }
    
    @objc private func addClicked() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
        
        present(TrackerSelectionScreenController(), animated: true)
    }
    
    @objc private func dateSelected(_ sender: UIDatePicker) {
        self.dateUpdateDelegate?.updateDate(date: sender.date)
    }
}
