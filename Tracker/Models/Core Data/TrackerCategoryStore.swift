//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 19.06.2023.
//

import UIKit
import CoreData

enum TrackerCategoryStoreError: Error {
    case invalidName
    case invalidUUID
}

struct TrackerCategoryStoreUpdate {
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
}

protocol TrackerCategoryStoreDelegate: AnyObject {
    func didUpdate(_ update: TrackerCategoryStoreUpdate)
}

final class TrackerCategoryStore: NSObject {
    static let shared = TrackerCategoryStore()
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<CDCategory>!

    weak var delegate: TrackerCategoryStoreDelegate?
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?

    var categories: [TrackerCategory] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let categories = try? objects.map({
                try self.getCategory(from: $0)
            })
        else {
            return []
        }
        return categories
    }

    convenience override init() {
        try! self.init(context: CoreDataManager.context)
    }

    private func createControllerAndFetch() throws {
        let fetchRequest = CDCategory.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \CDCategory.name, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        self.fetchedResultsController = controller
        try controller.performFetch()
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        try createControllerAndFetch()
    }

    func addNewCategory(_ newCategory: TrackerCategory) {
        let cdCategory = CDCategory(context: context)
        updateExistingCategory(cdCategory, with: newCategory)
    }

    func doesCategoryExist(named name: String) -> CDCategory? {
        let request = NSFetchRequest<CDCategory>(
            entityName: "CDCategory"
        )
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "name == %@", name)
        guard let category = try? context.fetch(request).first else {
            return nil
        }
        return category
    }

    func updateExistingCategoryName(from oldName: String, to newName: String) {
        let request = NSFetchRequest<CDCategory>(
            entityName: "CDCategory"
        )
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "name == %@", oldName)
        guard let category = try? context.fetch(request).first else { return }
        let categoryTrackers = category.trackers?.allObjects as? [CDTracker] ?? []
        updateExistingCategory(
            category,
            with: TrackerCategory(
                title: newName,
                trackers: castCDTrackers(categoryTrackers)
            )
        )
    }

    func updateExistingCategory(
        _ cdCategory: CDCategory,
        with category: TrackerCategory
    ) {
        cdCategory.name = category.title
        var trackers: [CDTracker] = []
        category.trackers.forEach { tracker in
            let cdTracker = CDTracker(context: context)
            cdTracker.id = tracker.id
            cdTracker.name = tracker.name
            cdTracker.color = tracker.color.getHex()
            cdTracker.emoji = tracker.emoji
            cdTracker.schedule = tracker.schedule.map {$0.rawValue}
            trackers.append(cdTracker)
        }
        cdCategory.trackers = NSSet(array: trackers)
        try? context.save()
    }

    func deleteCategory(withName categoryName: String) {
        let request = NSFetchRequest<CDCategory>(
            entityName: "CDCategory"
        )
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "name == %@", categoryName)
        guard let category = try? context.fetch(request).first else { return }
        context.delete(category)
        try? context.save()
    }

    func getCategory(from cdCategory: CDCategory) throws -> TrackerCategory {
        guard let trackers =
                cdCategory.trackers?.allObjects as? [CDTracker] else {
            throw TrackerCategoryStoreError.invalidUUID
        }
        guard let title = cdCategory.name else {
            throw TrackerCategoryStoreError.invalidName
        }
        return TrackerCategory(
            title: title,
            trackers: castCDTrackers(trackers)
        )
    }

    func castCDTrackers(_ trackerCD: [CDTracker]) -> [Tracker] {
        var trackers: [Tracker] = []
        trackerCD.forEach { tracker in
            var schedule: [WeekDay] = []
            tracker.schedule?.forEach { day in
                schedule.append(WeekDay(rawValue: day) ?? .monday)
            }
            trackers.append(
                Tracker(
                    id: tracker.id ?? UUID(),
                    name: tracker.name ?? "",
                    emoji: tracker.emoji ?? "",
                    color: UIColor().getColor(
                        from: tracker.color ?? ""
                    ),
                    schedule: schedule
                )
            )
        }
        return trackers
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let insertedIndexes,
           let deletedIndexes {
            delegate?.didUpdate(TrackerCategoryStoreUpdate(
                insertedIndexes: insertedIndexes,
                deletedIndexes: deletedIndexes
            )
            )
        }
        insertedIndexes = nil
        deletedIndexes = nil
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?
    ) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                deletedIndexes?.insert(indexPath.item)
            }
        case .insert:
            if let indexPath = newIndexPath {
                insertedIndexes?.insert(indexPath.item)
            }
        default:
            break
        }
    }
}
