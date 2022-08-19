//
//  DataService.swift
//  Wallet
//

import Foundation
import CoreData

class CacheService {
    let writeContext: NSManagedObjectContext
    private let persistentContainer = NSPersistentContainer(name: "wallet")
    private let readContext: NSManagedObjectContext
    
    init() {
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        readContext = persistentContainer.viewContext
        writeContext = persistentContainer.newBackgroundContext()
        writeContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
    }
    
    func createObject<T: Transient>(_ object: T) throws {
        object.makePersistent(context: writeContext)
        try saveWriteContext()
    }
    
    func objectWithSuchValueExists<Entity: NSManagedObject>(columnName: String,
                                                            value: String,
                                                            objectType: Entity.Type) -> Bool {
        
        let fetchRequest = createSafeComparisonFetchRequest(columnName: columnName, value: value, objectType: objectType)
        guard let objectCount = try? readContext.count(for: fetchRequest) else { return false }
        return objectCount > 0
    }
    
    func getObjectsByValue<Entity: NSManagedObject>(columnName: String,
                                                    value: String,
                                                    objectType: Entity.Type) -> [Entity] {
        
        let fetchRequest = createSafeComparisonFetchRequest(columnName: columnName, value: value, objectType: objectType)
        do {
            return try readContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func getAllObjectsOfType<Entity: NSManagedObject>(_ type: Entity.Type) -> [Entity] {
        let fetchRequest: NSFetchRequest<Entity> = NSFetchRequest(entityName: String(describing: type))
        do {
            return try readContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func deleteObjectsByValue<Entity: NSManagedObject>(columnName: String,
                                                       value: String,
                                                       objectType: Entity.Type) throws {
        
        let objects = getObjectsByValue(columnName: columnName, value: value, objectType: objectType)
        for object in objects {
            writeContext.delete(object)
        }
        try saveWriteContext()
    }
    
    func deleteAllObjectsOfType<Entity: NSManagedObject>(_ type: Entity.Type) throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = type.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try writeContext.execute(deleteRequest)
    }
    
    func createSafeComparisonFetchRequest<Entity: NSManagedObject>(columnName: String,
                                                                   value: String,
                                                                   objectType: Entity.Type) -> NSFetchRequest<Entity> {
        let fetchRequest: NSFetchRequest<Entity> = NSFetchRequest(entityName: String(describing: objectType))
        fetchRequest.predicate = NSComparisonPredicate(leftExpression: NSExpression(forKeyPath: columnName),
                                                       rightExpression: NSExpression(forConstantValue: value),
                                                       modifier: .direct,
                                                       type: .equalTo,
                                                       options: .caseInsensitive)
        return fetchRequest
    }
    
    func saveWriteContext() throws {
        guard writeContext.hasChanges else { return }
        
        do {
            try writeContext.save()
        } catch let error {
            writeContext.rollback()
            throw error
        }
    }
    
}
