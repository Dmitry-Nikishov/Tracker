//
//  CategoryCreationScreenController.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 26.06.2023.
//

import UIKit

protocol CategoryOperationsDelegate: AnyObject {
    func updateCategory(toName newCategoryName: String)
    func editingCategoryCanceled()
    func saveNewCategory(named name: String)

    var category: String { get }
}

final class CategoryCreationScreenController: StyledScreenController {
    weak var delegate: CategoryOperationsDelegate?
    private let analyticsService = AnalyticsService()

    private lazy var titleLabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.textColor = .appBlack
        view.textAlignment = .center
        view.numberOfLines = 0
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.7
        view.text = "NEW_CATEGORY".localized
        return view
    }()
    
    private lazy var stackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 16
        return view
    }()

    private lazy var categoryNameTextField: UITextField = {
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
        view.placeholder = "ENTER_CATEGORY_NAME".localized
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
    
    private lazy var errorLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        view.textColor = .appRedLight
        view.textAlignment = .center
        view.numberOfLines = 0
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.7
        view.text = "SYMBOLS_LIMIT_18".localized
        return view
    }()

    private lazy var finishedButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isEnabled = false
        view.backgroundColor = .appGray
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.setTitleColor(.appWhite, for: .normal)
        view.setTitle("DONE".localized, for: .normal)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.addTarget(nil, action: #selector(finishedButtonClicked), for: .touchUpInside)
        return view
    }()
    
    convenience init(delegate: CategoryOperationsDelegate? = nil) {
        self.init()
        self.delegate = delegate
    }

    private func setupKeyboardHiding(view: UIView) {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func setupSubViews() {
        view.backgroundColor = .appWhite
        setupKeyboardHiding(view: view)

        view.addSubview(titleLabel)
        stackView.addArrangedSubview(categoryNameTextField)
        stackView.addArrangedSubview(errorLabel)
        view.addSubview(stackView)
        view.addSubview(finishedButton)

        let constraints = [
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryNameTextField.heightAnchor.constraint(equalToConstant: 75),
            finishedButton.heightAnchor.constraint(equalToConstant: 60),
            finishedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            finishedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            finishedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        categoryNameTextField.delegate = self
        if delegate?.category != "" {
            titleLabel.text = "EDITING_CATEGORY".localized
            categoryNameTextField.text = delegate?.category ?? ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
        
        analyticsService.sendReport(
            event: AppConstants.YandexMobileMetrica.Events.open,
            params: [
                "screen": AppConstants.YandexMobileMetrica.Screens.categoryCreation
            ]
        )
    }

    override func viewWillDisappear(_ animated: Bool) {
        if delegate?.category != "" {
            delegate?.editingCategoryCanceled()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsService.sendReport(
            event: AppConstants.YandexMobileMetrica.Events.close,
            params: [
                "screen": AppConstants.YandexMobileMetrica.Screens.categoryCreation
            ]
        )
    }
    
    @objc private func finishedButtonClicked() {
        analyticsService.sendReport(
            event: AppConstants.YandexMobileMetrica.Events.click,
            params: [
                "screen": AppConstants.YandexMobileMetrica.Screens.categoryCreation,
                "item": AppConstants.YandexMobileMetrica.Items.confirmCategoryCreation
            ]
        )

        let categoryName = categoryNameTextField.text ?? ""
        if delegate?.category != "" {
            delegate?.updateCategory(toName: categoryName)
        } else {
            delegate?.saveNewCategory(named: categoryName)
        }
        self.dismiss(animated: true)
    }
}

extension CategoryCreationScreenController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String
    ) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {
            return false
        }
        let updatedText = currentText.replacingCharacters(
            in: stringRange,
            with: string
        )
        errorLabel.isHidden = !(updatedText.count >= 18)
        return updatedText.count <= 18
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        errorLabel.isHidden = true
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        let color: UIColor
        let isToBeEnabled: Bool
        if !(textField.text ?? "").isEmpty {
            color = .appBlack
            isToBeEnabled = true
        } else {
            color = .appGray
            isToBeEnabled = false
        }
        
        finishedButton.backgroundColor = color
        finishedButton.isEnabled = isToBeEnabled
    }
}

