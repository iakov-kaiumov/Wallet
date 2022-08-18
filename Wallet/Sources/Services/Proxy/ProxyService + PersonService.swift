//
//  ProxyService + PersonService.swift
//  Wallet
//

import Foundation

extension ProxyService: PersonServiceProtocol {
    func personServiceGet(completion: @escaping (Result<PersonApiModel, NetworkError>) -> Void) {
        networkService.personServiceGet(completion: completion)
    }
}
