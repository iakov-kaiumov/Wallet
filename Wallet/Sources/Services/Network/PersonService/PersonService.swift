//
//  PersonService.swift
//  Wallet
//

import Foundation

protocol PersonServiceProtocol: AnyObject {
    func personServiceGet(completion: @escaping (Result<PersonApiModel, NetworkError>) -> Void)
}

extension NetworkService: PersonServiceProtocol {
    func personServiceGet(completion: @escaping (Result<PersonApiModel, NetworkError>) -> Void) {
        let request = PersonRequestsFactory.makeGetRequest()
        requestProcessor.fetch(request, completion: completion)
    }
}
