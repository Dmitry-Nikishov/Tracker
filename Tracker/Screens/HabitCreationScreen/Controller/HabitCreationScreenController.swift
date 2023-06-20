//
//  HabitCreationScreenController.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 14.06.2023.
//

import UIKit

final class HabitCreationScreenController: StyledScreenController {
    let screenView = HabitCreationScreenView()
    private var presenter: HabitCreationScreenPresenter?
    var isNonRegularEvent: Bool = false

    convenience init(isNonRegularEvent: Bool) {
        self.init()
        self.isNonRegularEvent = isNonRegularEvent
    }

    private func configureKeyboardHiding() {
        let tap = UITapGestureRecognizer(
            target: view,
            action: #selector(UIView.endEditing)
        )
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
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
        view.backgroundColor = .appWhite
        view.addSubview(screenView)
        configureKeyboardHiding()
        setupConstraints()
        presenter = HabitCreationScreenPresenter(controller: self)
        screenView.delegate = self
        screenView.trackerTitleTextField.delegate = self
        screenView.optionsTableView.dataSource = self
        screenView.optionsTableView.delegate = self
        screenView.emojiCollectionView.dataSource = self
        screenView.emojiCollectionView.delegate = self
        screenView.colorCollectionView.dataSource = self
        screenView.colorCollectionView.delegate = self
        
        screenView
            .optionsTableView
            .heightAnchor
            .constraint(equalToConstant: isNonRegularEvent ? 75 : 150)
            .isActive = true
    }
    
    func unlockCreateButtonIfPossible() {
        if presenter?.canHabitBeCreated() ?? false {
            screenView.createButton.backgroundColor = .appBlack
            screenView.createButton.isEnabled = true
        } else {
            screenView.createButton.backgroundColor = .appGray
            screenView.createButton.isEnabled = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
    }
}

extension HabitCreationScreenController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String
    ) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false
        }
        let updatedText = currentText.replacingCharacters(
            in: stringRange,
            with: string
        )
        screenView.errorLabel.isHidden = updatedText.count < 38
        unlockCreateButtonIfPossible()
        return updatedText.count <= 38
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
        unlockCreateButtonIfPossible()
    }
}

extension HabitCreationScreenController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isNonRegularEvent ? 1 : 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        presenter?.setupCell(
            tableView: tableView,
            indexPath: indexPath
        ) ?? UITableViewCell()
    }
}

extension HabitCreationScreenController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let nextViewController = TrackerCategoryScreenController(delegate: presenter)
            present(nextViewController, animated: true)
        } else {
            let nextViewController = ScheduleConfigurationScreenController(delegate: presenter)
            present(nextViewController, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HabitCreationScreenController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.getNumberOfItems(forCollectionView: collectionView) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        presenter?.setupCell(
            collectionView: collectionView,
            indexPath: indexPath
        ) ?? UICollectionViewCell()
    }
}

extension HabitCreationScreenController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        presenter?.getItemSize(
            forCollectionView: collectionView
        ) ?? CGSize()
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        presenter?.getLineSpacing(
            forCollectionView: collectionView
        ) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        presenter?.getItemSpacing(
            forCollectionView: collectionView
        ) ?? 0
    }
}

extension HabitCreationScreenController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiCellView else {
                return
            }
            cell.frameView.isHidden = false
            presenter?.setSelectedEmoji(
                emoji: cell.emojiIconLabel.text ?? ""
            )
        } else if collectionView.tag == 2 {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCellView else {
                return
            }
            cell.frameView.layer.borderWidth = 3
            presenter?.setSelectedColor(
                color: cell.colorView.backgroundColor
            )
        }
        
        unlockCreateButtonIfPossible()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiCellView else { return }
            cell.frameView.isHidden = true
        } else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCellView else { return }
            cell.frameView.layer.borderWidth = 0
        }
    }
}

extension HabitCreationScreenController: HabitCreationScreenViewDelegate {
    func createNewTracker() {
        if let topController = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.rootViewController {
            let vc = topController.children.first?.children.first as? TrackersScreenController
            if let presenter = presenter {
                vc?.addTrackerCategory(
                    tracker: presenter.createNewTracker()
                )
            }
        }
        self.view.window!.rootViewController?.dismiss(
            animated: false,
            completion: nil
        )
    }
    
    func cancelNewTrackerCreation() {
        self.dismiss(animated: true)
    }
}
