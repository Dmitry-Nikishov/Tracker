//
//  TrackersScreenController.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 28.06.2023.
//

import UIKit

final class TrackersScreenController: StyledScreenController {
    private var viewModel: TrackersScreenViewModel?

    private lazy var dummyImage = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "dizzy")
        return view
    }()

    private lazy var dummyLabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        view.textColor = .appBlack
        view.textAlignment = .center
        view.numberOfLines = 0
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.7
        view.text = "Что будем отслеживать?"
        return view
    }()
    
    private lazy var stackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fill
        view.spacing = 14
        return view
    }()
    
    private lazy var searchTextField = {
        let view = UISearchTextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.placeholder = "Поиск"
        view.backgroundColor = .appLightGray.withAlphaComponent(0.12)
        view.textColor = .appBlack
        view.attributedPlaceholder = NSAttributedString(
            string: view.placeholder ?? "",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.appGray
            ]
        )
        view.clearButtonMode = .never
        return view
    }()
    
    private lazy var discardButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        view.setTitleColor(.appWhite, for: .normal)
        view.setTitle("Отменить", for: .normal)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.addTarget(
            nil,
            action: #selector(discardButtonTapped),
            for: .touchUpInside
        )

        view.setTitleColor(.appBlue, for: .normal)
        view.isHidden = true
        return view
    }()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.register(
            TrackerCollectionCell.self,
            forCellWithReuseIdentifier: String(
                describing: TrackerCollectionCell.self
            )
        )
        view.register(
            TrackerScreenHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: String(describing: TrackerScreenHeaderView.self)
        )
        view.allowsMultipleSelection = false
        view.contentInset = UIEdgeInsets(
            top: 24,
            left: 0,
            bottom: 80,
            right: 0
        )
        view.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        return view
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .appBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.setTitleColor(.appWhite, for: .normal)
        button.setTitle("Фильтры", for: .normal)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        return button
    }()

    private func setupEndEditingGesture() {
        let tap = UITapGestureRecognizer(
            target: view,
            action: #selector(UIView.endEditing)
        )
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func setCollectionView(toBeHidden: Bool) {
        dummyImage.isHidden = toBeHidden ? false : true
        dummyLabel.isHidden = toBeHidden ? false : true
        collectionView.isHidden = toBeHidden ? true : false
        filterButton.isHidden = toBeHidden ? true : false
    }

    private func setupBindings() {
        guard let viewModel = viewModel else { return }
        viewModel.$shouldCollectionBeReloaded.bind { [weak self] newValue in
            if newValue {
                self?.collectionView.reloadData()
            }
        }
        viewModel.$shouldCollectionBeHidden.bind { [weak self] newValue in
            self?.setCollectionView(toBeHidden: newValue)
        }
    }

    private func setupSubViews() {
        view.backgroundColor = .appWhite
        setupEndEditingGesture()

        view.addSubview(dummyImage)
        view.addSubview(dummyLabel)
        stackView.addArrangedSubview(searchTextField)
        stackView.addArrangedSubview(discardButton)
        view.addSubview(stackView)
        view.addSubview(collectionView)
        view.addSubview(filterButton)

        let constraints = [
            dummyImage.heightAnchor.constraint(equalToConstant: 80),
            dummyImage.widthAnchor.constraint(equalTo: dummyImage.heightAnchor),
            dummyImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dummyImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            dummyLabel.topAnchor.constraint(equalTo: dummyImage.bottomAnchor, constant: 8),
            dummyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -17)
        ]
        NSLayoutConstraint.activate(constraints)
        
        setCollectionView(toBeHidden: true)
        viewModel = TrackersScreenViewModel()
        
        setupBindings()
        viewModel?.checkDataExistence()
        (navigationController as? NavigationController)?.dateUpdateDelegate = self
        searchTextField.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
    }
    
    @objc private func discardButtonTapped() {
        searchTextField.text = ""
        textFieldDidChange()
        discardButton.isHidden = true
        becomeFirstResponder()
    }
    
    @objc private func textFieldDidChange() {
        viewModel?.didEnter(searchTextField.text)
        viewModel?.searchTrackers(by: searchTextField.text ?? "")
    }
    
    func addData(_ data: TrackerCategory) {
        viewModel?.addNewTracker(data)
    }

    func updateCollectionView() {
        viewModel?.refreshData()
    }
}

extension TrackersScreenController: UISearchTextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String
    ) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let searchText = currentText.replacingCharacters(in: stringRange, with: string)
        discardButton.isHidden = !(searchText.count > 0)
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension TrackersScreenController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel?.getNumberOfCategories() ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.getNumberOfTrackersForCategory(index: section) ?? 0
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

extension TrackersScreenController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        
        let headerView = self.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
            at: indexPath
        )
        
        return headerView.systemLayoutSizeFitting(
            CGSize(
                width: collectionView.frame.width,
                height: UIView.layoutFittingExpandedSize.height
            ),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let availableWidth = collectionView.frame.width - 40
        let cellWidth =  availableWidth / CGFloat(2)
        return CGSize(width: cellWidth,
                      height: cellWidth * 2 / 2.5)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(
            top: 12,
            left: 16,
            bottom: 32,
            right: 16
        )
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 8
    }
}

extension TrackersScreenController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        viewModel?.setupHeader(
            type: kind,
            collectionView: collectionView,
            indexPath: indexPath
        ) ?? UICollectionReusableView()
    }
}

extension TrackersScreenController: DateUpdateDelegate {
    func updateDate(date: Date) {
        viewModel?.updateCurrentDate(to: date)
        viewModel?.searchTrackers(by: searchTextField.text ?? "")
    }
}
