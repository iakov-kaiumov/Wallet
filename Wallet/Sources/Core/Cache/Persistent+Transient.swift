//
//  Persistent+Transient.swift
//  Wallet
//

import Foundation
import CoreData

protocol Persistent {
    associatedtype TransientEntity: Transient
    @discardableResult func makeTransient() -> TransientEntity?
}

protocol Transient {
    associatedtype PersistentEntity: NSManagedObject
    @discardableResult func makePersistent(context: NSManagedObjectContext) -> PersistentEntity?
}
