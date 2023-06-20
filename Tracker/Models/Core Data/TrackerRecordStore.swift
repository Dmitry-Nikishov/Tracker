//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 19.06.2023.
//

import UIKit
import CoreData

enum TrackerRecordStoreError: Error {
    case invalidDate
    case invalidUUID
}

protocol TrackerRecordStoreDelegate: AnyObject {
    func didUpdate(_ update: TrackerCategoryStoreUpdate)
}

final class TrackerRecordStore: NSObject {
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<CDTrackerRecord>!
    weak var delegate: TrackerCategoryStoreDelegate?
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?

    var trackers: [TrackerRecord] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let categories = try? objects.map({
                try self.getRecord(from: $0)
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
        let fetchRequest = CDTrackerRecord.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \CDTrackerRecord.date, ascending: true)
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

    func addNewRecord(_ record: TrackerRecord) {
        let cdRecord = CDTrackerRecord(context: context)
        updateExistingRecord(cdRecord, with: record)
    }

    func updateExistingRecord(
        _ cdRecord: CDTrackerRecord,
        with record: TrackerRecord
    ) {
        cdRecord.id = record.id
        cdRecord.date = record.date
        try? context.save()
    }

    func deleteTracker(_ tracker: TrackerRecord) {
        let request = NSFetchRequest<CDTrackerRecord>(
            entityName: "CDTrackerRecord"
        )
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(
            format: "id == %@ and date == %@",
            tracker.id as CVarArg,
            tracker.date
        )
        guard let category = try? context.fetch(request).first else { return }
        context.delete(category)
        try? context.save()
    }

    func getRecord(from cdRecord: CDTrackerRecord) throws -> TrackerRecord {
        guard let uuid = cdRecord.id else {
            throw TrackerRecordStoreError.invalidUUID
        }
        guard let date = cdRecord.date else {
            throw TrackerRecordStoreError.invalidDate
        }
        return TrackerRecord(id: uuid, date: date)
    }
}

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate(
            TrackerCategoryStoreUpdate(
                insertedIndexes: insertedIndexes!,
                deletedIndexes: deletedIndexes!
            )
        )
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
