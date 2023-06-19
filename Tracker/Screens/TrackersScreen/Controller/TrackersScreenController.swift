//
//  TrackersScreenController.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 08.06.2023.
//

import UIKit

final class TrackersScreenController: StyledScreenController {    
    let screenView = TrackersScreenView()
    private var presenter: TrackersScreenPresenter?
    
    private func setupEndEditingGesture() {
        let tap = UITapGestureRecognizer(
            target: self,
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
    
    func setCollectionView(toBeHidden: Bool) {
        screenView.dummyImage.isHidden = toBeHidden ? false : true
        screenView.dummyLabel.isHidden = toBeHidden ? false : true
        screenView.collectionView.isHidden = toBeHidden ? true : false
        screenView.filterButton.isHidden = toBeHidden ? true : false
    }
    
    private func setupDelegatesAndSources() {
        screenView.delegate = self
        screenView.searchTextField.delegate = self
        screenView.collectionView.dataSource = self
        screenView.collectionView.delegate = self
        
        (navigationController as? NavigationController)?.dateUpdateDelegate = self
    }
    
    private func setupSubViews() {
        view.addSubview(screenView)
        view.backgroundColor = .appWhite
        
        setupEndEditingGesture()
        setupConstraints()
        setCollectionView(toBeHidden: true)
        presenter = TrackersScreenPresenter(viewController: self)
        setupDelegatesAndSources()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
    }
    
    func addTrackerCategory(tracker: TrackerCategory) {
        presenter?.addNewTracker(tracker)
    }

    func updateCollectionView() {
        presenter?.updateData()
        screenView.collectionView.reloadData()
    }
}

extension TrackersScreenController: DateUpdateDelegate {
    func updateDate(date: Date) {
        presenter?.updateCurrentDate(date: date)
        presenter?.searchTrackers(
            by: screenView.searchTextField.text ?? ""
        )
    }
}

extension TrackersScreenController: TrackersScreenViewDelegate {
    func discardSearch() {
        screenView.searchTextField.text = ""
        screenView.discardButton.isHidden = true
        presenter?.searchTrackers(by: "")
        becomeFirstResponder()
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
        screenView.discardButton.isHidden = !(searchText.count > 0)
        presenter?.searchTrackers(by: searchText)
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension TrackersScreenController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        presenter?.getNumberOfCategories() ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        presenter?.getNumberOfTrackersForCategory(index: section) ?? 0
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
        presenter?.setupHeader(
            type: kind,
            collectionView: collectionView,
            indexPath: indexPath
        ) ?? UICollectionReusableView()
    }
}


