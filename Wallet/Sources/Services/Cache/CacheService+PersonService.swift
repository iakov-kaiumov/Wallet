//
//  CacheService+PersonService.swift
//  Wallet
//

import Foundation

protocol PersonCacheServiceProtocol: AnyObject {
    func getPerson() -> CDPerson?
    func savePerson(person: CDPerson)
}

extension CacheService: PersonCacheServiceProtocol {
    func getPerson() -> CDPerson? {
        let request = CDPerson.fetchRequest()
        return try? persistentContainer.viewContext.fetch(request).first
    }
    
    func savePerson(person: CDPerson) {
        // TODO: - Save Person
    }
}
