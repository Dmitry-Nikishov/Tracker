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

    private let trackerCategoryStore = TrackerCategoryStore.shared
    private let trackerRecordStore = TrackerRecordStore()
    private var categories: [TrackerCategory] = []
    private var allCategories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    private var currentDate: Date = Date()
    private var currentSearchText: String = ""

    init() {
        completedTrackers = Set(trackerRecordStore.trackers)
        refreshData()
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
        let completionLabelSuffix = Converters.daysToStringSuffix(days: completions)
        cell.counterLabel.text = "\(completions) \(completionLabelSuffix)"
        cell.taskLabel.text = item.emoji
        cell.taskName.text = item.name
        cell.delegate = self
        return cell
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
}

extension TrackersScreenViewModel: TrackerCollectionCellDelegate {
    func doTask(trackerId: UUID) {
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

