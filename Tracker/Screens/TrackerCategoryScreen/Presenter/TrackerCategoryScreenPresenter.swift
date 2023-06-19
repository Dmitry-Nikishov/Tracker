//
//  TrackerCategoryScreenPresenter.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 16.06.2023.
//

import UIKit

final class TrackerCategoryScreenPresenter {
    private weak var controller: TrackerCategoryScreenController?
    private let store = TrackerCategoryStore.shared
    private var categories: [String] = []
    private var previouslySelectedCategory = ""
    private var oldCategory = ""

    private func updateTableViewHiddenState(isToBeHidden: Bool) {
        controller?.setTableViewVisibleState(isToBeHidden: isToBeHidden)
    }
    
    init(controller: TrackerCategoryScreenController? = nil) {
        self.controller = controller
        store.delegate = self
        categories = store.categories.map { $0.title }
        updateTableViewHiddenState(isToBeHidden: categories.isEmpty)
    }
    
    func updateTableViewVisibility() {
        updateTableViewHiddenState(isToBeHidden: categories.isEmpty)
    }
    
    func setPreviouslySelectedCategory(with categoryName: String) {
        previouslySelectedCategory = categoryName
    }

    func getNumberOfCategories() -> Int {
        categories = store.categories.map { $0.title }
        return categories.count
    }
    
    func getSelectedCategory(forIndexPath indexPath: IndexPath) -> String {
        return categories[indexPath.row]
    }

    func deleteCategoryFromStore(at index: Int) {
        store.deleteCategory(withName: categories[index])
    }

    func editCategory(at index: Int) {
        oldCategory = categories[index]
        controller?.present(
            CategoryCreationScreenController(delegate: self),
            animated: true
        )
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

}

extension TrackerCategoryScreenPresenter: CategoryOperationsDelegate {
    var category: String {
        oldCategory
    }

    func editingCategoryCanceled() {
        oldCategory = ""
    }
        
    func updateCategory(toName newCategory: String) {
        store.updateExistingCategoryName(from: oldCategory, to: newCategory)
        controller?.screenView.categoriesTableView.reloadData()
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
            controller?.screenView.categoriesTableView.reloadData()
            updateTableViewHiddenState(isToBeHidden: categories.isEmpty)
        }
    }
}

extension TrackerCategoryScreenPresenter: TrackerCategoryStoreDelegate {
    func didUpdate(_ update: TrackerCategoryStoreUpdate) {
        guard let tableView = controller?.screenView.categoriesTableView else {
            return
        }
        
        tableView.performBatchUpdates {
            let insertedIndexPaths = update.insertedIndexes.map {
                IndexPath(item: $0, section: 0)
            }
            let deletedIndexPaths = update.deletedIndexes.map {
                IndexPath(item: $0, section: 0)
            }
            tableView.insertRows(at: insertedIndexPaths, with: .automatic)
            tableView.deleteRows(at: deletedIndexPaths, with: .fade)
        }
    }
}

