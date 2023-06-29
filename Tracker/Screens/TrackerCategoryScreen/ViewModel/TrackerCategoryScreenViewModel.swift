//
//  TrackerCategoryScreenViewModel.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 26.06.2023.
//

import UIKit

final class TrackerCategoryScreenViewModel {
    @Observable
    private(set) var isData: Bool = false

    @Observable
    private(set) var shouldTableBeReloaded: Bool = false

    @Observable
    private(set) var updates: TrackerCategoryStoreUpdate?

    private let store = TrackerCategoryStore.shared
    private var categories: [String] = []
    private var previouslySelectedCategory = ""
    private var oldCategory = ""

    func checkDataPresence() {
        isData = !categories.isEmpty
    }

    init() {
        store.delegate = self
        categories = store.categories.map { $0.title }
        checkDataPresence()
    }
    
    func getNumberOfCategories() -> Int {
        categories = store.categories.map { $0.title }
        return categories.count
    }

    func configureCell(
        forTableView tableView: UITableView,
        atIndexPath indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = CategorySelectionCell()
        cell.backgroundColor = .appGray.withAlphaComponent(0.3)
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(
            top: 0,
            left: 15,
            bottom: 0,
            right: 15
        )

        cell.categoryLabel.text = categories[indexPath.row]
        
        if indexPath.row == categories.count - 1 {
            cell.separatorInset = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: 0,
                right: tableView.bounds.width
            )
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [
                .layerMinXMaxYCorner,
                .layerMaxXMaxYCorner
            ]
        } else if indexPath.row == 0 {
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner
            ]
        }
        
        if !previouslySelectedCategory.isEmpty {
            if indexPath.row == categories.firstIndex(of: previouslySelectedCategory) {
                tableView.selectRow(
                    at: indexPath,
                    animated: false,
                    scrollPosition: .none
                )
                cell.accessoryType = .checkmark
            }
        }
        return cell
    }

    func setPreviouslySelectedCategory(with categoryName: String) {
        previouslySelectedCategory = categoryName
    }

    func getSelectedCategory(forIndexPath indexPath: IndexPath) -> String {
        return categories[indexPath.row]
    }

    func deleteCategory(at index: Int) {
        store.deleteCategory(withName: categories[index])
        shouldTableBeReloaded = true
        checkDataPresence()
    }

    func editCategory(at index: Int) {
        oldCategory = categories[index]
    }
}

extension TrackerCategoryScreenViewModel: CategoryOperationsDelegate {
    var category: String {
        oldCategory
    }

    func editingCategoryCanceled() {
        oldCategory = ""
    }
    

    func updateCategory(toName newCategory: String) {
        store.updateExistingCategoryName(
            from: oldCategory,
            to: newCategory
        )
        
        shouldTableBeReloaded = true
        checkDataPresence()
    }

    func saveNewCategory(named name: String) {
        if !categories.contains(name) {
            categories.append(name)
            store.addNewCategory(
                TrackerCategory(
                    title: name,
                    trackers: []
                )
            )
            
            shouldTableBeReloaded = true
            checkDataPresence()
        }
    }
}

extension TrackerCategoryScreenViewModel: TrackerCategoryStoreDelegate {
    func didUpdate(_ update: TrackerCategoryStoreUpdate) {
        isData = categories.isEmpty
        updates = update
    }
}

