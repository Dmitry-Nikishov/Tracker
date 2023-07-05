//
//  TrackersScreenViewModel.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 28.06.2023.
//

import UIKit

final class TrackersScreenViewModel {
    @Observable
    private(set) var shouldCollectionBeHidden: Bool = false

    @Observable
    private(set) var shouldCollectionBeReloaded: Bool = false

    private let analyticsService = AnalyticsService()
    private let trackerCategoryStore = TrackerCategoryStore.shared
    private let trackerRecordStore = TrackerRecordStore()
    private var categories: [TrackerCategory] = []
    private var allCategories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    private var currentDate: Date = Date()
    private var currentSearchText: String = ""
    private var hasPinnedCategory: Bool {
        categories.contains(where: { $0.title == "PINNED".localized })
    }
    private var currentlyEditingIndex: IndexPath?

    init() {
        completedTrackers = Set(trackerRecordStore.trackers)
        refreshData()
    }
    
    deinit {
        analyticsService.sendReport(
            event: AppConstants.YandexMobileMetrica.Events.close,
            params: [
                "screen": AppConstants.YandexMobileMetrica.Screens.trackers
            ]
        )
    }
    
    func checkDataExistence() {
        shouldCollectionBeHidden = categories.isEmpty
    }

    func getNumberOfCategories() -> Int {
        return categories.count
    }

    func getNumberOfTrackersForCategory(index: Int) -> Int {
        return categories[index].trackers.count
    }

    func setupHeader(type: String,
                     collectionView: UICollectionView,
                     indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch type {
        case UICollectionView.elementKindSectionHeader:
            guard let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: type,
                withReuseIdentifier: String(describing: TrackerScreenHeaderView.self),
                for: indexPath
            ) as? TrackerScreenHeaderView else {
                return UICollectionReusableView()
            }
            view.titleLabel.text = "\(categories[indexPath.section].title)"
            return view
        case UICollectionView.elementKindSectionFooter:
            return UICollectionReusableView()
        default:
            return UICollectionReusableView()
        }
    }

    func refreshData() {
        allCategories = trackerCategoryStore.categories
        if hasPinnedCategory, allCategories[0].trackers.isEmpty {
            allCategories.remove(at: 0)
        }
        searchTrackers(by: currentSearchText)
        shouldCollectionBeReloaded = true
    }

    func setupCell(
        collectionView: UICollectionView,
        indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: TrackerCollectionCell.self),
            for: indexPath
        ) as? TrackerCollectionCell else {
            return UICollectionViewCell()
        }
        
        let item = categories[indexPath.section].trackers[indexPath.row]
        let completions = completedTrackers.filter({ $0.id == item.id }).count
        
        if !completedTrackers.filter({
            $0.id == item.id && $0.date == currentDate.dateString }).isEmpty {
            cell.counterButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            cell.counterButton.backgroundColor = item.color.withAlphaComponent(0.3)
        } else {
            cell.counterButton.setImage(UIImage(systemName: "plus"), for: .normal)
            cell.counterButton.backgroundColor = item.color
        }
        cell.trackerId = item.id
        cell.taskArea.backgroundColor = item.color
        cell.counterLabel.text = completions.localized
        cell.taskLabel.text = item.emoji
        cell.taskName.text = item.name
        cell.delegate = self
        
        cell.pinIcon.isHidden = !item.isPinned
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 16
        return cell
    }

    func setupViewController(forSelectedItemAt indexPath: IndexPath) -> UIViewController {
        currentlyEditingIndex = indexPath
        let tracker = categories[indexPath.section].trackers[indexPath.row]
        let count = completedTrackers.filter({ $0.id == tracker.id}).count
        let viewController = HabitCreationScreenController(trackerToEdit: tracker, counter: count)
        return viewController
    }

    func updateCurrentDate(to date: Date) {
        currentDate = date
    }

    func searchTrackers(by searchText: String) {
        categories = []
        if searchText == "" {
            allCategories.forEach { category in
                let filtered = category.trackers.filter {
                    $0.schedule.contains(
                        WeekDay.getWeekDay(for: currentDate)
                    )
                }
                
                if filtered.count > 0 {
                    categories.append(
                        TrackerCategory(
                            title: category.title,
                            trackers: filtered
                        )
                    )
                }
            }
        } else {
            allCategories.forEach { category in
                let filtered = category.trackers.filter {
                    $0.name.contains(searchText) &&
                    $0.schedule.contains(
                        WeekDay.getWeekDay(for: currentDate)
                    )
                }
                if filtered.count > 0 {
                    categories.append(
                        TrackerCategory(
                            title: category.title,
                            trackers: filtered
                        )
                    )
                }
            }
        }
        
        if let pinnedCategoryIndex = categories.firstIndex(
            where: {
                $0.title == "PINNED".localized
            }
        ) {
            let pinnedCategory = categories.remove(at: pinnedCategoryIndex)
            categories.insert(pinnedCategory, at: 0)
        }
        
        shouldCollectionBeHidden = categories.count == 0
        shouldCollectionBeReloaded = true
    }
    
    func addNewTracker(_ data: TrackerCategory) {
        allCategories = trackerCategoryStore.categories
        var updatedAllCategories = allCategories
        let index: Int? = updatedAllCategories.firstIndex { category in
            category.title == data.title
        }
        
        guard let index else {
            updatedAllCategories.append(data)
            allCategories = updatedAllCategories
            trackerCategoryStore.addNewCategory(data)
            searchTrackers(by: currentSearchText)
            return
        }
        var trackersList = updatedAllCategories[index].trackers
        trackersList.append(contentsOf: data.trackers)
        updatedAllCategories[index] = TrackerCategory(
            title: data.title,
            trackers: trackersList
        )
        allCategories = updatedAllCategories
        if let existingCategory = trackerCategoryStore.doesCategoryExist(
            named: data.title) {
            trackerCategoryStore.updateExistingCategory(
                existingCategory,
                with: TrackerCategory(
                    title: data.title,
                    trackers: trackersList)
            )
        }
        searchTrackers(by: currentSearchText)
    }

    func didEnter(_ text: String?) {
        currentSearchText = text ?? ""
    }
    
    func deleteTracker(with indexPath: IndexPath, withRecords: Bool = false) {
        let category = categories[indexPath.section]
        let tracker = category.trackers[indexPath.row]
        var trackersList = category.trackers
        trackersList.remove(at: indexPath.row)
        if let existingCategory = trackerCategoryStore.doesCategoryExist(named: category.title) {
            trackerCategoryStore.updateExistingCategory(
                existingCategory,
                with: TrackerCategory(
                    title: category.title,
                    trackers: trackersList
                )
            )
        }
        if withRecords {
            let trackerRecordsToDelete = completedTrackers.filter { $0.id == tracker.id }
            completedTrackers = completedTrackers.filter { $0.id != tracker.id }
            trackerRecordsToDelete.forEach { trackerRecord in
                trackerRecordStore.deleteTracker(trackerRecord)
            }
        }
        refreshData()
    }

    func pinTracker(with indexPath: IndexPath) {
        var tracker = categories[indexPath.section].trackers[indexPath.row]
        tracker.isPinned = true
        deleteTracker(with: indexPath)
        addNewTracker(
            TrackerCategory(
                title: "PINNED".localized,
                trackers: [tracker]
            )
        )
    }

    func unpinTracker(with indexPath: IndexPath) {
        var tracker = categories[indexPath.section].trackers[indexPath.row]
        tracker.isPinned = false
        deleteTracker(with: indexPath)
        addNewTracker(
            TrackerCategory(
                title: tracker.categoryName,
                trackers: [tracker]
            )
        )
    }

    func updateTracker(_ trackerCategory: TrackerCategory, counter: Int) {
        guard let tracker = trackerCategory.trackers.first,
              let index = currentlyEditingIndex else { return }
        if tracker.isPinned {
            deleteTracker(with: index)
            addNewTracker(
                TrackerCategory(
                    title: "PINNED".localized,
                    trackers: [tracker]
                )
            )
        } else {
            deleteTracker(with: index)
            addNewTracker(
                TrackerCategory(
                    title: tracker.categoryName,
                    trackers: [tracker]
                )
            )
        }
        let oldCount = completedTrackers.filter({ $0.id == tracker.id}).count
        if oldCount > counter {
            for _ in 1...(oldCount - counter) {
                if let element = completedTrackers.first(where: { $0.id == tracker.id }) {
                    completedTrackers.remove(element)
                    trackerRecordStore.deleteTracker(element)
                }
            }
        } else if oldCount < counter {
            for _ in 1...(counter - oldCount) {
                let newRecord = TrackerRecord(id: tracker.id, date: Date.randomDate)
                completedTrackers.insert(newRecord)
                trackerRecordStore.addNewRecord(newRecord)
            }
        }
    }

    func hasPinned() -> Bool {
        hasPinnedCategory
    }
}

extension TrackersScreenViewModel: TrackerCollectionCellDelegate {
    func doTask(trackerId: UUID) {
        analyticsService.sendReport(
            event: AppConstants.YandexMobileMetrica.Events.click,
            params: [
                "screen": AppConstants.YandexMobileMetrica.Screens.trackers,
                "item": AppConstants.YandexMobileMetrica.Items.completeTrack
            ]
        )
        let finishedTask = TrackerRecord(
            id: trackerId,
            date: currentDate.dateString
        )
        
        if completedTrackers.contains(finishedTask) {
            completedTrackers.remove(finishedTask)
            trackerRecordStore.deleteTracker(finishedTask)
        } else {
            completedTrackers.insert(finishedTask)
            trackerRecordStore.addNewRecord(finishedTask)
        }
        
        shouldCollectionBeReloaded = true
    }
}

