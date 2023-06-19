//
//  CategoryCreationScreenView.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 16.06.2023.
//

import UIKit

protocol CategoryCreationScreenViewDelegate: AnyObject {
    func handleNewCategory()
}

final class CategoryCreationScreenView: UIView {
    weak var delegate: CategoryCreationScreenViewDelegate?

    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.textColor = .appBlack
        view.textAlignment = .center
        view.numberOfLines = 0
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.7
        view.text = "Новая категория"
        return view
    }()

    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 16
        return view
    }()
    
    lazy var categoryNameTextField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .appLightGray.withAlphaComponent(0.12)
        view.textColor = .appBlack
        view.attributedPlaceholder = NSAttributedString(
            string: "Placeholder Text",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.appGray
            ])
        
        if let button = view.value(forKey: "clearButton") as? UIButton {
            button.tintColor = .appGray
            button.setImage(
                UIImage(
                    systemName: "xmark.circle.fill"
                )?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        view.placeholder = "Введите название категории"
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.backgroundColor = .appGray.withAlphaComponent(0.3)
        view.clearButtonMode = .always
        view.clearButtonMode = .whileEditing
        view.leftView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: 15,
                height: view.frame.height
            )
        )
        view.leftViewMode = .always
        return view
    }()

    lazy var errorLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        view.textColor = .appRedLight
        view.textAlignment = .center
        view.numberOfLines = 0
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.7
        view.text = "Ограничение кол-ва символов : 18"
        return view
    }()

    lazy var finishedButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isEnabled = false
        view.backgroundColor = .appGray
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.setTitleColor(.appWhite, for: .normal)
        view.setTitle("Готово", for: .normal)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.addTarget(nil, action: #selector(finishedButtonClicked), for: .touchUpInside)
        return view
    }()

    private func setupSubViews() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        stackView.addArrangedSubview(categoryNameTextField)
        stackView.addArrangedSubview(errorLabel)
        addSubview(stackView)
        addSubview(finishedButton)

        let constraints = [
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            categoryNameTextField.heightAnchor.constraint(equalToConstant: 75),
            finishedButton.heightAnchor.constraint(equalToConstant: 60),
            finishedButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            finishedButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            finishedButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented for CategoryCreationScreenView")
    }
    
    @objc private func finishedButtonClicked() {
        delegate?.handleNewCategory()
    }
}

