//
//  CacheService+PersonService.swift
//  Wallet
//

import Foundation

protocol PersonCacheServiceProtocol: AnyObject {
    func getPerson() -> PersonModel?
    func savePerson(person: PersonModel)
}

extension CacheService: PersonCacheServiceProtocol {
    func getPerson() -> PersonModel? {
        guard let persistentPerson = getAllObjectsOfType(PersonModel.PersistentEntity.self)?.first,
              let transientPerson = persistentPerson.makeTransient() else { return nil }
        return transientPerson
    }
    
    func savePerson(person: PersonModel) {
        _ = person.makePersistent(context: writeContext)
        try? saveWriteContext()
    }
    
}
