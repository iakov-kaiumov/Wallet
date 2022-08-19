//
//  PersonService.swift
//  Wallet
//

import Foundation

protocol PersonServiceDelegate: AnyObject {
    func personService(_ service: PersonServiceProtocol, didLoadPersonInfo person: PersonApiModel)
}

protocol PersonServiceProtocol: AnyObject {
    func addDelegate(_ delegate: PersonServiceDelegate)
    
    func personServiceGet(completion: @escaping (Result<PersonApiModel, NetworkError>) -> Void)
}

extension NetworkService: PersonServiceProtocol {
    func addDelegate(_ delegate: PersonServiceDelegate) {
        personDelegates.addDelegate(delegate)
    }
    
    func personServiceGet(completion: @escaping (Result<PersonApiModel, NetworkError>) -> Void) {
        let request = PersonRequestsFactory.makeGetRequest()
        requestProcessor.fetch(request, completion: completion)
    }
}
