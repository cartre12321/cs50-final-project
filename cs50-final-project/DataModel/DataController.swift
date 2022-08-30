//
//  DataController.swift
//  cs50-final-project
//
//  Created by Carter Riddall on 2022-06-29.
//

import Foundation
import CoreData

// Create a single controller for Core Data
class DataController: ObservableObject {
    
    // Create permanent reference to the Managed Object Context
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Create persistent container
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        // Load existing data
        container.loadPersistentStores { description, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        return container
    }()
    
    // Save Managed Object Context through DataController class (keeping it centralized)
    static func save() -> Bool {
        // Catch any errors thrown
        do {
            try self.context.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    // Delete object from Managed Object Context and save
    static func delete(_ object: NSManagedObject) {
        self.context.delete(object)
        if self.save() {
            print("Item removed")
        } else {
            print("Item could not be removed")
        }
    }
    
}
