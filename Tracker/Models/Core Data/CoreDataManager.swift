//
//  CoreDataManager.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 19.06.2023.
//

import UIKit
import CoreData

struct CoreDataManager {
    static let
    context = (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer
        .viewContext
}
