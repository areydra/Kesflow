//
//  KesflowManager.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 3/17/25.
//

import Foundation
import CoreData

class KesflowManager {
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    static let instance = KesflowManager()
    
    private init() {
        container = NSPersistentContainer(name: "KesflowContainer")
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                print("Error while loading persistent stores: \(error)")
            } else {
                print("Success loading persistent stores: \(description)")
            }
        }
        context = container.viewContext
    }
}
