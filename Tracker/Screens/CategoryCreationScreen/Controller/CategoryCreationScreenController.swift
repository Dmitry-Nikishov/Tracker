//
//  CategoryCreationScreenController.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 16.06.2023.
//

import UIKit

protocol CategoryOperationsDelegate: AnyObject {
    func updateCategory(toName newCategoryName: String)
    func editingCategoryCanceled()
    func saveNewCategory(named name: String)

    var category: String { get }
}

final class CategoryCreationScreenController: StyledScreenController {
    let screenView = CategoryCreationScreenView()
    weak var delegate: CategoryOperationsDelegate?

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
        view.addSubview(screenView)
        setupKeyboardHiding(view: view)

        let constraints = [
            screenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            screenView.topAnchor.constraint(equalTo: view.topAnchor),
            screenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            screenView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        screenView.delegate = self
        screenView.categoryNameTextField.delegate = self
        if delegate?.category != "" {
            screenView.titleLabel.text = "Редактирование категории"
            screenView.categoryNameTextField.text = delegate?.category ?? ""
        }
    }

    override func viewDidLoad() {
        setupSubViews()
    }

    override func viewWillDisappear(_ animated: Bool) {
        if delegate?.category != "" {
            delegate?.editingCategoryCanceled()
        }
    }
}

extension CategoryCreationScreenController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String
    ) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        screenView.errorLabel.isHidden = !(updatedText.count >= 18)
        return updatedText.count <= 18
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        screenView.errorLabel.isHidden = true
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
        
        screenView.finishedButton.backgroundColor = color
        screenView.finishedButton.isEnabled = isToBeEnabled
    }
}

extension CategoryCreationScreenController: CategoryCreationScreenViewDelegate {
    func handleNewCategory() {
        let category = screenView.categoryNameTextField.text ?? ""
        if delegate?.category != "" {
            delegate?.updateCategory(toName: category)
        } else {
            delegate?.saveNewCategory(named: category)
        }
        self.dismiss(animated: true)
    }
}

