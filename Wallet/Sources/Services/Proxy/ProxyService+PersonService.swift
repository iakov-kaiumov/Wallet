//
//  ProxyService+PersonService.swift
//  Wallet
//

import Foundation

extension ProxyService: PersonNetworkServiceProtocol {
    func createSelf(_ person: PersonApiModel, completion: @escaping (Result<PersonApiModel, NetworkError>) -> Void) {
        networkService.createSelf(person) { result in
            self.cacheService.savePerson(person: CDPerson())
            completion(result)
        }
    }
    
}
