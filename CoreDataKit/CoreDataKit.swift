//
//  CoreDataKit.swift
//  CoreDataKit
//
//  Created by Mathijs Kadijk on 23-06-14.
//  Copyright (c) 2014 Mathijs Kadijk. All rights reserved.
//

import CoreData

public typealias CompletionHandler = (NSError?) -> Void

public class CoreDataKit : NSObject
{
    private struct DefaultCoordinator {
        static var instance: NSPersistentStoreCoordinator?
    }

    public class var persistentStoreCoordinator: NSPersistentStoreCoordinator? {
        get {
            return DefaultCoordinator.instance
        }

        set {
            DefaultCoordinator.instance = newValue
        }
    }

    public class var rootContext: NSManagedObjectContext {
        struct Singleton {
            static let instance = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType, persistentStoreCoordinator: CoreDataKit.persistentStoreCoordinator!)
        }

        return Singleton.instance
    }

    public class var mainThreadContext: NSManagedObjectContext {
        struct Singleton {
            static let instance = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType, parentContext: CoreDataKit.rootContext)
        }

        return Singleton.instance
    }

// MARK: - Saving

    public class func save(saveBlock: () -> Void, completion: CompletionHandler?) {
        let savingContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType, parentContext: CoreDataKit.rootContext)

        savingContext.performBlock {
            saveBlock()
            savingContext.saveToPersistentStore(completion)
        }
    }

    public class func save(saveBlock: () -> Void) {
        save(saveBlock, completion: nil)
    }
}