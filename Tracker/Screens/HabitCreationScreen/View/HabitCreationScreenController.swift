//
//  HabitCreationScreenController.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 27.06.2023.
//

import UIKit

final class HabitCreationScreenController: StyledScreenController {
    var viewModel: HabitCreationScreenViewModel?
    var isNonRegularEvent: Bool = false

    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.textColor = .appBlack
        view.textAlignment = .center
        view.numberOfLines = 0
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.7
        view.text = "Новая привычка"
        return view
    }()

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentSize = CGSize(
            width: UIScreen.main.bounds.width,
            height: 820
        )
        view.isPagingEnabled = false
        view.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        return view
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 16
        return view
    }()

    private lazy var trackerTitleTextField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.placeholder = "Введите название трекера"
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.backgroundColor = .appGray.withAlphaComponent(0.3)
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
        view.addTarget(nil, action: #selector(textFieldChangeHandler), for: .editingChanged)
        return view
    }()

    private lazy var errorLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        view.textColor = .appRed
        view.textAlignment = .center
        view.numberOfLines = 0
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.7
        view.text = "Ограничение кол-ва символов : 38"
        view.isHidden = true
        return view
    }()

    private lazy var optionsTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.backgroundColor = .appGray.withAlphaComponent(0.3)

        view.register(
            CategoryCellView.self,
            forCellReuseIdentifier: String(describing: CategoryCellView.self)
        )
        view.register(
            ScheduleCellView.self,
            forCellReuseIdentifier: String(describing: ScheduleCellView.self)
        )
        return view
    }()

    private lazy var emojiTitleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        view.textColor = .appBlack
        view.textAlignment = .center
        view.numberOfLines = 0
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.7
        view.text = "Emoji"
        return view
    }()

    private lazy var emojiCollectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(
            EmojiCellView.self,
            forCellWithReuseIdentifier: String(
                describing: EmojiCellView.self
            )
        )
        view.allowsMultipleSelection = false
        view.tag = 1
        view.backgroundColor = .clear
        return view
    }()

    private lazy var colorTitleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        view.textColor = .appBlack
        view.textAlignment = .center
        view.numberOfLines = 0
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.7
        view.text = "Цвет"
        return view
    }()

    private lazy var colorCollectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        view.allowsMultipleSelection = false
        view.tag = 2
        view.backgroundColor = .clear
        view.register(
            ColorCellView.self,
            forCellWithReuseIdentifier: String(
                describing: ColorCellView.self
            )
        )
        return view
    }()

    private lazy var tapsView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 8
        return view
    }()

    private lazy var cancelButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .appWhite
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.setTitleColor(.appRed, for: .normal)
        view.setTitle("Отменить", for: .normal)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.appRedLight.cgColor
        view.addTarget(
            nil,
            action: #selector(cancelButtonClicked),
            for: .touchUpInside
        )
        
        return view
    }()
    
    private lazy var createButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .appGray
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.setTitleColor(.appWhite, for: .normal)
        view.setTitle("Создать", for: .normal)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.isEnabled = false
        view.addTarget(
            nil,
            action: #selector(createButtonClicked),
            for: .touchUpInside
        )
        return view
    }()

    convenience init(isNonRegularEvent: Bool) {
        self.init()
        self.isNonRegularEvent = isNonRegularEvent
    }
    
    @objc
    private func createButtonClicked() {
        if let top = UIApplication.shared.windows.filter({
            $0.isKeyWindow
        }).first?.rootViewController {
            let destination = top.children.first?.children.first as? TrackersScreenController
            if let viewModel = viewModel {
                destination?.addData(viewModel.createNewTracker())
            }
        }
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
    @objc
    private func cancelButtonClicked() {
        self.dismiss(animated: true)
    }
    
    private func configureKeyboardHiding() {
        let tap = UITapGestureRecognizer(
            target: view,
            action: #selector(UIView.endEditing)
        )
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func setupBinding() {
        guard let viewModel = viewModel else { return }
        viewModel.$shouldCreateButtonBeUnlocked.bind { [weak self] _ in
            self?.modifyCreateButtonState()
        }
    }

    private func setupDelegates() {
        trackerTitleTextField.delegate = self
        optionsTableView.dataSource = self
        optionsTableView.delegate = self
        emojiCollectionView.dataSource = self
        emojiCollectionView.delegate = self
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
    }
    
    private func setupSubView() {
        view.backgroundColor = .appWhite
        configureKeyboardHiding()
        
        view.addSubview(titleLabel)
        stackView.addArrangedSubview(trackerTitleTextField)
        stackView.addArrangedSubview(errorLabel)
        scrollView.addSubview(stackView)
        scrollView.addSubview(optionsTableView)
        scrollView.addSubview(emojiTitleLabel)
        scrollView.addSubview(emojiCollectionView)
        scrollView.addSubview(colorTitleLabel)
        scrollView.addSubview(colorCollectionView)
        tapsView.addArrangedSubview(cancelButton)
        tapsView.addArrangedSubview(createButton)
        scrollView.addSubview(tapsView)
        view.addSubview(scrollView)

        let constraints = [
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackerTitleTextField.heightAnchor.constraint(equalToConstant: 75),
            optionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            optionsTableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 24),
            optionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emojiTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            emojiTitleLabel.topAnchor.constraint(equalTo: optionsTableView.bottomAnchor, constant: 32),
            emojiCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emojiCollectionView.topAnchor.constraint(equalTo: emojiTitleLabel.bottomAnchor, constant: 32),
            emojiCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 156),
            colorTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            colorTitleLabel.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 32),
            colorCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            colorCollectionView.topAnchor.constraint(equalTo: colorTitleLabel.bottomAnchor, constant: 32),
            colorCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 156),
            tapsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tapsView.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 30),
            tapsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tapsView.heightAnchor.constraint(equalToConstant: 60)
        ]
        NSLayoutConstraint.activate(constraints)
        
        viewModel = HabitCreationScreenViewModel(isNonRegularEvent: isNonRegularEvent)
        setupBinding()
        setupDelegates()
        
        optionsTableView
            .heightAnchor
            .constraint(equalToConstant: isNonRegularEvent ? 75 : 150)
            .isActive = true
        
        if isNonRegularEvent {
            titleLabel.text = "Новое нерегулярное событие"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubView()
    }
    
    @objc private func textFieldChangeHandler() {
        viewModel?.setTrackerName(trackerTitleTextField.text)
    }
    
    private func modifyCreateButtonState() {
        if viewModel?.canHabitBeCreated() ?? false {
            createButton.backgroundColor = .appBlack
            createButton.isEnabled = true
        } else {
            createButton.backgroundColor = .appGray
            createButton.isEnabled = false
        }
    }
}

extension HabitCreationScreenController: UITextFieldDelegate {
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
        errorLabel.isHidden = updatedText.count < 38
        modifyCreateButtonState()
        return updatedText.count <= 38
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
        modifyCreateButtonState()
    }
}

extension HabitCreationScreenController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isNonRegularEvent ? 1: 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModel?.setupCell(
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
        viewModel?.updateCurrentlySelectedCell(to: tableView.cellForRow(at: indexPath))
        if indexPath.row == 0 {
            let nextViewController = TrackerCategoryScreenController(delegate: viewModel,
                                                                     viewModel: TrackerCategoryScreenViewModel())
            present(nextViewController, animated: true)
        } else {
            let nextViewController = ScheduleConfigurationScreenController(delegate: viewModel)
            present(nextViewController, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HabitCreationScreenController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.getNumberOfItems(forCollectionView: collectionView) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        viewModel?.setupCell(
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
        viewModel?.getItemSize(forCollectionView: collectionView) ?? CGSize()
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        viewModel?.getLineSpacing(forCollectionView: collectionView) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        viewModel?.getItemSpacing(forCollectionView: collectionView) ?? 0
    }
}

extension HabitCreationScreenController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiCellView else { return }
            cell.frameView.isHidden = false
            viewModel?.setSelectedEmoji(emoji: cell.emojiIconLabel.text ?? "")
        } else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCellView else { return }
            cell.frameView.layer.borderWidth = 3
            viewModel?.setSelectedColor(color: cell.colorView.backgroundColor)
        }
        modifyCreateButtonState()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiCellView else {
                return
            }
            cell.frameView.isHidden = true
        } else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCellView else {
                return
            }
            cell.frameView.layer.borderWidth = 0
        }
    }
}
