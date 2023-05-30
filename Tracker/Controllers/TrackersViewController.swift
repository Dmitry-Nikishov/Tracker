//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 23.05.2023.
//

import UIKit

final class TrackersViewController: UIViewController {
    private var currentDate = Date()
    private var completedTrackers: Set<TrackerRecord> = []
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    private var textOfSearchQuery = ""

    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.calendar.firstWeekday = 2
        
        datePicker.addTarget(
            self,
            action: #selector(handleDatePicker),
            for: .valueChanged
        )
        return datePicker
    }()

    private lazy var searchField: UISearchController = {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        return searchController
    }()

    private lazy var trackerCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        
        collectionView.register(
            TrackerCollectionViewCell.self,
            forCellWithReuseIdentifier: String(
                describing: TrackerCollectionViewCell.self
            )
        )
        
        collectionView.register(
            TrackerHeaderCollectionView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: String(
                describing: TrackerHeaderCollectionView.self
            )
        )
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()

    private lazy var infoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "searchError")
        return imageView
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ничего не найдено"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .appBlack
        label.textAlignment = .center
        return label
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
    
    private func setupController() {
        configureNavigationItem()
        configureView()
    }
    
    private func configureNavigationItem() {
        navigationItem.title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.leftBarButtonItem?.tintColor = .appBlack
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(addTracker)
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            customView: datePicker
        )
                
        navigationItem.searchController = searchField
    }
    
    private func configureView() {
        view.backgroundColor = .appWhite
                
        view.addSubview(infoImageView)
        view.addSubview(infoLabel)
        view.addSubview(trackerCollectionView)
        
        let constraints = [
            infoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            infoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoImageView.heightAnchor.constraint(equalToConstant: 80),
            infoImageView.widthAnchor.constraint(equalToConstant: 80),
            
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoLabel.topAnchor.constraint(equalTo: infoImageView.bottomAnchor, constant: 8),
            infoLabel.heightAnchor.constraint(equalToConstant: 18),

            trackerCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackerCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trackerCollectionView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            trackerCollectionView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            )
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        trackerCollectionView.isHidden = categories.isEmpty
        
        infoLabel.isHidden = !categories.isEmpty
        infoLabel.text = "Что будем отслеживать?"
        infoImageView.image = UIImage(named: "dizzy")
        infoImageView.isHidden = !categories.isEmpty
    }
        
    private func updateCategories(newCategory: TrackerCategory) {
        if let index =
            categories.firstIndex(
                where: { $0.title == newCategory.title }
            ) {

            let totalTrackers =
            categories[index].trackers + newCategory.trackers
            
            categories[index] = TrackerCategory(
                title: newCategory.title,
                trackers: totalTrackers
            )
        } else {
            categories.append(newCategory)
        }
    }

    private func updateVisibleCategories() {
        let filteredCategories = categories.map {
            TrackerCategoryManipulator.getTrackersCategoryFilteredByDate(
                category: $0,
                searchQuery: textOfSearchQuery,
                date: currentDate
            )
        }.filter{
            !$0.trackers.isEmpty
        }
                
        if filteredCategories.isEmpty && textOfSearchQuery.isEmpty {
            infoLabel.text = "Ничего не найдено"
            infoImageView.image = UIImage(named: "searchError")
        }
        
        visibleCategories = filteredCategories
        trackerCollectionView.reloadData()
    }

    @objc private func addTracker() {
        let vc = NewTrackerTypeViewController(categories: categories)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc private func handleDatePicker() {
        currentDate = datePicker.date
        self.dismiss(animated: false)
        updateVisibleCategories()
    }
}

extension TrackersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        textOfSearchQuery = searchController.searchBar.text ?? ""
        updateVisibleCategories()
    }
}

extension TrackersViewController: TrackerCategoryAddable {
    func addNewTrackerCategory(_ category: TrackerCategory) {
        dismiss(animated: true)
        
        let trackerCategory = TrackerCategoryManipulator.appendSchedulePointIfNeeded(
            category: category,
            currentDate: currentDate
        )
        
        updateCategories(newCategory: trackerCategory)
                
        trackerCollectionView.reloadData()
        updateVisibleCategories()
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        trackerCollectionView.isHidden = visibleCategories.count == 0
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(
                describing: TrackerCollectionViewCell.self
            ),
            for: indexPath
        ) as? TrackerCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        
        let daysCount = completedTrackers.filter{
            $0.id == tracker.id
        }.count
        
        let isFinishedToday = completedTrackers.contains(
            where: {
                $0.id == tracker.id &&
                $0.date.isEqualByDayGranularity(
                    other: currentDate
                )
            }
        )
                
        cell.delegate = self
        cell.configureCell(with: tracker)
        cell.configureRecord(
            daysCount: daysCount,
            isFinishedToday: isFinishedToday
        )
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: String(
                describing: TrackerHeaderCollectionView.self
            ),
            for: indexPath
        ) as? TrackerHeaderCollectionView  else {
            return UICollectionReusableView()
        }

        view.configureTitle(visibleCategories[indexPath.section].title)
        return view
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    private var lineSpacing: CGFloat { return 16 }
    private var sideInset: CGFloat { return 16 }
    private var interItemSpacing: CGFloat { return 9 }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = (
            collectionView.frame.width -
            interItemSpacing -
            2 * sideInset
        ) / 2
        return CGSize(width: width, height: 148)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(
            CGSize(width: collectionView.frame.width,
                   height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        lineSpacing
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        interItemSpacing
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(
            top: 12,
            left: sideInset,
            bottom: sideInset,
            right: sideInset
        )
    }
}

extension TrackersViewController: TrackerCollectionViewCellDelegate {
    func addButtonTapped(cell: TrackerCollectionViewCell) {
        let index = trackerCollectionView.indexPath(for: cell) ?? IndexPath()
        let id = visibleCategories[index.section].trackers[index.row].id
        let isFinishedToday: Bool
        var days = completedTrackers.filter{ $0.id == id }.count
        
        if !completedTrackers.contains(
            where: {
                $0.id == id &&
                $0.date.isEqualByDayGranularity(
                    other: currentDate
                )
            }
        ) {
            completedTrackers.insert(
                TrackerRecord(id: id, date: currentDate)
            )
            days += 1
            isFinishedToday = true
        } else {
            completedTrackers = completedTrackers.filter {
                !(
                    $0.id == id &&
                    $0.date.isEqualByDayGranularity(other: currentDate)
                )
            }
            days -= 1
            isFinishedToday = false
        }
        
        cell.configureRecord(
            daysCount: days,
            isFinishedToday: isFinishedToday
        )
    }
}
