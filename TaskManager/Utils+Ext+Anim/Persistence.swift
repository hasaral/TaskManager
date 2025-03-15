//
//  Persistence.swift
//  TaskManager
//
//  Created by Hasan Saral on 11.03.2025.
//

import CoreData

class CoreDataProvider {
    
    let persistentContainer: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
 
    
    init(inMemory: Bool = false) {
        persistentContainer = NSPersistentCloudKitContainer(name: "TaskManager")
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Core Data store failed to initialize \(error)")
            }
        }
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
}
