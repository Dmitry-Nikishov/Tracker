//
//  TrackersScreenPresenter.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 08.06.2023.
//

import UIKit

final class TrackersScreenPresenter {
    private weak var viewController: TrackersScreenController?
    private let trackerCategoryStore = TrackerCategoryStore.shared
    private let trackerRecordStore = TrackerRecordStore()
    private var categories: [TrackerCategory] = []
    private var allCategories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    private var currentDate: Date = Date()
    
    init(viewController: TrackersScreenController? = nil) {
        self.viewController = viewController
        completedTrackers = Set(trackerRecordStore.trackers)
        updateData()
    }
    
    private func checkCategories() {
        viewController?.setCollectionView(toBeHidden: categories.isEmpty)
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
        
        viewController?.setCollectionView(toBeHidden: categories.count == 0)
        viewController?.screenView.collectionView.reloadData()
    }

    func updateCurrentDate(date: Date) {
        currentDate = date
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
            searchTrackers(
                by: viewController?.screenView.searchTextField.text ?? ""
            )
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
        searchTrackers(by: viewController?.screenView.searchTextField.text ?? "")
    }

    func updateData() {
        allCategories = trackerCategoryStore.categories
        searchTrackers(
            by: viewController?.screenView.searchTextField.text ?? ""
        )
    }
}

extension TrackersScreenPresenter: TrackerCollectionCellDelegate {
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
        
        viewController?.screenView.collectionView.reloadData()
    }
}

