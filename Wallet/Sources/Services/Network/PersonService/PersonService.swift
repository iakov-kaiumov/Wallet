//
//  PersonService.swift
//  Wallet
//

import Foundation

protocol PersonNetworkServiceProtocol: AnyObject {
    func createSelf(_ person: PersonApiModel, completion: @escaping (Result<PersonApiModel, NetworkError>) -> Void)
}

extension NetworkService: PersonNetworkServiceProtocol {
    func createSelf(
        _ person: PersonApiModel,
        completion: @escaping (Result<PersonApiModel, NetworkError>) -> Void
    ) {
        let request = PersonRequestsFactory.makeCreateReqeust(person: person)
        requestProcessor.fetch(request) { result in
            completion(result)
        }
    }
}
