//
//  DelegatesList.swift
//  Wallet
//

import Foundation

final class DelegatesList<T>: Sequence {
    // MARK: - Properties
    private let delegatesHashTable = NSHashTable<AnyObject>.weakObjects()
    
    // MARK: - Init
    init() { }
    
    // MARK: - Public methods
    func addDelegate(_ delegate: T) {
        delegatesHashTable.add(delegate as AnyObject)
    }
    
    // MARK: Sequence
    func makeIterator() -> Array<T>.Iterator {
        let delegates = delegatesHashTable.allObjects.compactMap { $0 as? T }
        return delegates.makeIterator()
    }
}
